Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYJFXEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYJFXEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYJFXEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:04:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39150 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJFXEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:04:00 -0400
Date: Tue, 7 Oct 2008 01:10:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes (Re: 2.6.27-rc8+ - first impressions)
Message-ID: <20081006231002.GN3180@one.firstfloor.org>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 10:39:25PM +0100, Maciej W. Rozycki wrote:
> On Mon, 6 Oct 2008, Andi Kleen wrote:
> 
> > The real reason is actually a workaround in the BIOS for problems
> > in the older Linux code that caused duplicated timer interrupts. The
> > old Linux would fall into "enable both IO-APIC and 8259" fallback mode
> > and the resulted in duplicated timer events, which made everything unhappy.
> > They instead configured the northbridge in a way that one of the inputs
> > is ignored.
> 
>  Hmm, working around Linux problems in the BIOS is a new and truly odd 
> concept to me. 

Except perhaps for the cheapest consumer parts and many laptops Linux is 
definitely on the radar now for many BIOS developers.

> It's not that we are unresponsive or do not take 
> responsibility for our bugs, is it?

These workarounds are not for mainline kernels but for specific
distribution releases (as in "fixes SLES/RHEL x.y" instead of 
"fixes 2.6.xy")

Even when the distributors update their kernels the old releases
do not go away are still used and the workarounds get in.

> > You won't be able to DMI list it, that workaround is widely used
> > in lots of different systems.
> 
>  Well, perhaps, but the thermal trip point phenomenon seems unique to this 
> family of systems.  The other aspects of the problem do not really matter 
> anymore as we seem to have addressed them robustly enough now.

When you need DMI entries you clearly haven't.

-Andi

