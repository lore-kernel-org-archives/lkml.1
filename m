Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXE1VqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXE1VqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbXE1Vp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:45:57 -0400
Received: from www.osadl.org ([213.239.205.134]:58937 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752349AbXE1Vpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:45:55 -0400
Subject: Re: b44: regression in 2.6.22 (resend)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200705282255.56490.maxi@daemonizer.de>
References: <20070525172431.60affaca@freepuppy>
	 <200705281944.05030.maxi@daemonizer.de> <1180380230.3657.3.camel@chaos>
	 <200705282255.56490.maxi@daemonizer.de>
Content-Type: text/plain
Date: Mon, 28 May 2007 23:45:52 +0200
Message-Id: <1180388752.3657.13.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-28 at 22:55 +0200, Maximilian Engelhardt wrote:
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

Can you please apply

http://www.tglx.de/projects/hrtimers/2.6.22-rc3/patch-2.6.22-rc3-hrt1.patch

on top of rc3 and check, whether it has any effect on your problem.

> The other issue happens only with 2.6.22-rc2-mm1 which includes the b44 ssb 
> spilt. It's independed wether High Resolution Timer is turned on or off I 
> always get very varying and high ping times. The iperf-test doesn't show the 
> problems from 2.6.21/22-rc3.

Neither with nor without highres ?

	tglx


