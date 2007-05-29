Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbXE2PVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbXE2PVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXE2PV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:21:29 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1569 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXE2PV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:21:28 -0400
X-Server-Uuid: A6C4E0AE-A7F0-449F-BAE7-7FA0D737AC76
Subject: Re: b44: regression in 2.6.22 (resend)
From: "Gary Zambrano" <zambrano@broadcom.com>
To: "Maximilian Engelhardt" <maxi@daemonizer.de>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Michael Buesch" <mb@bu3sch.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Jeff Garzik" <jgarzik@pobox.com>, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200705282255.56490.maxi@daemonizer.de>
References: <20070525172431.60affaca@freepuppy>
 <200705281944.05030.maxi@daemonizer.de> <1180380230.3657.3.camel@chaos>
 <200705282255.56490.maxi@daemonizer.de>
Date: Tue, 29 May 2007 06:58:43 -0700
Message-ID: <1180447123.17146.4.camel@dhcp-10-12-136-115.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5)
X-WSS-ID: 6A429B603CG1520377-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-28 at 13:55 -0700, Maximilian Engelhardt wrote:
> On Monday 28 May 2007, Thomas Gleixner wrote:
> > On Mon, 2007-05-28 at 19:44 +0200, Maximilian Engelhardt wrote:
> > > > Can you please keep CONFIG_HIGH_RES_TIMERS and CONFIG_NOHZ and try the
> > > > following combinations on the kernel command line:
> > > >
> > > > 1) highres=off nohz=off (should be the same as your working config)
> > > > 2) highres=off
> > > > 3) nohz=off
> > >
> > > I tested this with my 2.6.22-rc3 kernel, here are the results:
> > >
> > > without any special boot parameters: problem does appear
> > > highres=off nohz=off: problem does not appear
> > > highres=off: problem does not appear
> > > nohz=off: problem does appear
> >
> > Is there any other strange behavior of the high res enabled kernel than
> > the b44 problem ?
> 
> I didn't notice anything.
> 
> >
> > > I additionally built my 2.6.22-rc2-mm1 kernel without High Resolution
> > > Timer, but the high ping problem is still there.
> >
> > Hmm, that's mysterious. Wild guess is that highres exposes the hidden
> > "feature" in a different way than rc2-mm1 does.
> 
> I think the bug in 2.6.21/22-rc3 is a different one that the one in 
> 2.6.22-rc2-mm1, but that's also only a wild guess :)
> 
> I'll explain this a bit:
> In 2.6.21/22-rc3 is the same b44 driver that has been in the stock kernels for 
> some time. With this driver and High Resolution Timer turned on I get 
> problems using iperf. The problems are that the systems becomes really slow 
> and unresponsive.  Michael Buesch thought this could be an IRQ storm which 
> sounds logical to me. This bug did never happen to me before I startet the 
> iperf test.


Can you please check to see if you notice anything out of the ordinary
using netperf in place of iperf in your high res timer on/off testbed?

Thanks,
Gary







