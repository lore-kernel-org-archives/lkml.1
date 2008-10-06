Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYJFVjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYJFVjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYJFVje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:39:34 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:59785 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbYJFVjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:39:33 -0400
Date: Mon, 6 Oct 2008 22:39:25 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
 (Re: 2.6.27-rc8+ - first impressions)
In-Reply-To: <87tzbpmocm.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu>
 <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, Andi Kleen wrote:

> The real reason is actually a workaround in the BIOS for problems
> in the older Linux code that caused duplicated timer interrupts. The
> old Linux would fall into "enable both IO-APIC and 8259" fallback mode
> and the resulted in duplicated timer events, which made everything unhappy.
> They instead configured the northbridge in a way that one of the inputs
> is ignored.

 Hmm, working around Linux problems in the BIOS is a new and truly odd 
concept to me.  It's not that we are unresponsive or do not take 
responsibility for our bugs, is it?

> You won't be able to DMI list it, that workaround is widely used
> in lots of different systems.

 Well, perhaps, but the thermal trip point phenomenon seems unique to this 
family of systems.  The other aspects of the problem do not really matter 
anymore as we seem to have addressed them robustly enough now.

  Maciej
