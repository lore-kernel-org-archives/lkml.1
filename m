Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYJGBfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYJGBfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYJGBfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:35:07 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:39753 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYJGBfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:35:06 -0400
Date: Tue, 7 Oct 2008 02:35:01 +0100 (BST)
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
In-Reply-To: <20081006231002.GN3180@one.firstfloor.org>
Message-ID: <alpine.LFD.1.10.0810070142060.10470@ftp.linux-mips.org>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu>
 <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006231002.GN3180@one.firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Andi Kleen wrote:

> >  Hmm, working around Linux problems in the BIOS is a new and truly odd 
> > concept to me. 
> 
> Except perhaps for the cheapest consumer parts and many laptops Linux is 
> definitely on the radar now for many BIOS developers.

 That's not my point.

> > It's not that we are unresponsive or do not take 
> > responsibility for our bugs, is it?
> 
> These workarounds are not for mainline kernels but for specific
> distribution releases (as in "fixes SLES/RHEL x.y" instead of 
> "fixes 2.6.xy")

 I am happy to fix any bugs I introduced myself (as much as one can be 
happy about mistakes once they have discovered they made them that is) and 
certainly have a look into other Linux bugs by request of any vendor of a 
Linux distribution made on behalf of a hardware manufacturer.

 OTOH I do not feel responsible even a little bit for someone else's bugs 
like those of BIOS developers.  Though I will certainly consider providing 
them with any assistance needed to get things related to Linux resolved in 
a best possible way if they ask nicely.

> Even when the distributors update their kernels the old releases
> do not go away are still used and the workarounds get in.

 It is not unreasonable to require a version of a distribution that is 
current at the time a piece of hardware has been released.  Hardware 
vendors only support certain versions of certain operating systems if any 
at all and Linux makes no difference here.  Except from the bureaucracy 
needed, or actually the lack of, to get something we have done wrong 
rectified.  The community may support anything beyond that of course, like 
running Linux 1.2.13 on that brand new server.

> >  Well, perhaps, but the thermal trip point phenomenon seems unique to this 
> > family of systems.  The other aspects of the problem do not really matter 
> > anymore as we seem to have addressed them robustly enough now.
> 
> When you need DMI entries you clearly haven't.

 You can't just break a piece of hardware randomly (setting the thermal 
trip points based on an interrupt mask of an I/O APIC input is certainly 
beyond the ACPI spec), hide its documentation and still demand it to be 
supported correctly, possibly hurting all the other good equipment.  
Sorry -- you have to draw a line somewhere.  Others seem to agree as 
otherwise we wouldn't have DMI matching in the first place.  The same 
applies to PCI quirks.  And command line arguments to activate workarounds 
are worse yet, but we do have them too.  We wouldn't need any of these if 
all the hardware was built to the relevant specs.

  Maciej
