Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZBTVwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZBTVwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZBTVvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:51:55 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:17105
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750765AbZBTVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:51:54 -0500
X-BigFish: VPS-32(zz1432R98dR148cM1805M936fKzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KFDWQ1-01-H20-01
Date: Fri, 20 Feb 2009 22:51:23 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Hounschell <dmarkh@cfl.rr.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090220215123.GI4834@alberich.amd.com>
References: <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <20090220115357.GE4834@alberich.amd.com> <20090220123402.GA26418@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090220123402.GA26418@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 21:51:44.0987 (UTC) FILETIME=[6C22B2B0:01C993A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 01:34:02PM +0100, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > On Thu, Feb 19, 2009 at 10:54:19AM -0500, Mark Hounschell wrote:
> > > Borislav Petkov wrote:
> > > > On Thu, Feb 19, 2009 at 10:16:40AM -0500, Mark Hounschell wrote:
> > > >> Andreas Herrmann wrote:
> > > >>> Hi Mark,
> > > >>>
> > > >>> Can you please provide us output of lspci -vvxxx.
> > > >>> (Please run this as root.)
> > > >>>
> > > 
> > > Attached...
> > > 
> > > 
> > > >>> Furthermore you can try booting your 1000HZ kernel
> > > >>> with following kernel command lines:
> > > >>>
> > 
> > Thanks for trying this out.
> > But nothing suspicious found. I.e. timer/hpet interrupt is enabled
> > and its routing seems to be ok.
> > 
> > Here's one more check that's worth trying: In one of your logs I've
> > seen that HPET id reports 3 timers but later on 4 timers were detected
> > for HPET.
> > 
> > To check what's going on I'd like to see the HPET 
> > configuration in the course of booting your system.  Please 
> > apply attached patch and boot with hpet=debug -- both with 
> > 250HZ and with 1000HZ -- and provide dmesg output.
> 
> Mind sending this patch as a hpet=verbose feature patch which we 
> could queue up for upstream merging? We have hpet problems 
> frequently, so some built-in debug/verbosity trigger would be 
> nice.

Yup, work is in progress.

Andreas


