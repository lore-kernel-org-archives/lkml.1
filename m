Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYJGMEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYJGMEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 08:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYJGMEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 08:04:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55783 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbYJGMEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 08:04:46 -0400
Date: Tue, 7 Oct 2008 14:04:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
	(Re: 2.6.27-rc8+ - first impressions)
Message-ID: <20081007120428.GA4392@elte.hu>
References: <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006231002.GN3180@one.firstfloor.org> <alpine.LFD.1.10.0810070142060.10470@ftp.linux-mips.org> <20081007053808.GB20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007053808.GB20740@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Oct 07, 2008 at 02:35:01AM +0100, Maciej W. Rozycki wrote:
> > 
> > > > It's not that we are unresponsive or do not take 
> > > > responsibility for our bugs, is it?
> > > 
> > > These workarounds are not for mainline kernels but for specific
> > > distribution releases (as in "fixes SLES/RHEL x.y" instead of 
> > > "fixes 2.6.xy")
> > 
> >  I am happy to fix any bugs I introduced myself (as much as one can 
> > be happy about mistakes once they have discovered they made them 
> > that is) and certainly have a look into other Linux bugs by request 
> > of any vendor of a Linux distribution made on behalf of a hardware 
> > manufacturer.
> > 
> >  OTOH I do not feel responsible even a little bit for someone else's 
> > bugs like those of BIOS developers.  Though I will certainly 
> > consider providing them with any assistance needed to get things 
> > related to Linux resolved in a best possible way if they ask nicely.
> 
> To be honest I think you have a unrealistic approach to this. That is 
> not how it works.
>
> For the BIOS developers OS are like some piece of random hardware ot a 
> OS developer. If something doesn't work and if they care they will add 
> a workaround. Just as the OS developer adds a workaround for the 
> hardware issue. And yes workarounds are typically not pretty. And 
> sometimes the workaround come later back to bite someone That is what 
> happened here. But they still have to support the old releases if they 
> worked before, otherwise they got a regression too.
> 
> Using a PCI ID quirk to disable the workaround is a reasonable 
> approach, although it has its issues too.
> 
> Also calling the workaround a BIOS bug is just unfair in this case. It 
> really isn't.

The BIOS causes all thermal trip points to be 16C when the kernel pokes 
the IO-APIC pins, causing the system to be very slow and causing the CPU 
fan to spin like mad. That is utterly broken. So stop wasting our time 
with your stupid nonsense.

	Ingo
