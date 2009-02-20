Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZBTQJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZBTQJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZBTQJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:09:16 -0500
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:9967 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751754AbZBTQJQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:09:16 -0500
X-BigFish: VPS-44(zz3b49K1432R98dR936eQ148cM1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KFDGV0-02-CRU-01
Date: Fri, 20 Feb 2009 17:08:43 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090220160843.GF4834@alberich.amd.com>
References: <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <20090220115357.GE4834@alberich.amd.com> <499ECF87.2070204@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <499ECF87.2070204@cfl.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 16:09:04.0604 (UTC) FILETIME=[8D3139C0:01C99375]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 10:43:03AM -0500, Mark Hounschell wrote:
> Andreas Herrmann wrote:
> > On Thu, Feb 19, 2009 at 10:54:19AM -0500, Mark Hounschell wrote:
> >> Borislav Petkov wrote:
> >>> On Thu, Feb 19, 2009 at 10:16:40AM -0500, Mark Hounschell wrote:
> >>>> Andreas Herrmann wrote:
> >>>>> Hi Mark,
> >>>>>
> >>>>> Can you please provide us output of lspci -vvxxx.
> >>>>> (Please run this as root.)
> >>>>>
> >> Attached...
> >>
> >>
> >>>>> Furthermore you can try booting your 1000HZ kernel
> >>>>> with following kernel command lines:
> >>>>>
> > 
> > Thanks for trying this out.
> > But nothing suspicious found. I.e. timer/hpet interrupt is enabled
> > and its routing seems to be ok.
> > 
> > Here's one more check that's worth trying: In one of your logs I've
> > seen that HPET id reports 3 timers but later on 4 timers were detected
> > for HPET.
> > 
> > To check what's going on I'd like to see the HPET configuration in the
> > course of booting your system.  Please apply attached patch and boot
> > with hpet=debug -- both with 250HZ and with 1000HZ -- and provide dmesg
> > output.
> > 
> > 
> 
> Here is the short 1000Hz bootlog. I'm afraid non of your debug output made it
> out however.

Sigh.

> I thought it was because it just wasn't getting that far but
> looking at the 250Hz log I don't see any there either???


> The patch applied (with fuz) to both kernel sources and I built/installed them
> from clean. I don't find any messages starting with "hpet:" in either trace???

Your 250HZ kernel was built on Feb, 2nd, right?
So the patch wasn't applied I guess, no?

> Linux version 2.6.28.3-1000Hz (root@harley) (gcc version 4.3.1 20080507
> (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #7 SMP PREEMPT Fri Feb
> 20 09:01:29 EST 2009

I assume the patch was aplied.

> Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1
> 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux)
> ) #7 SMP PREEMPT Fri Feb 2 0 09:01:54 EST 2009

Here I doubt that's the right kernel -- at least it was not built today.
Can you please double check this.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


