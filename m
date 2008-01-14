Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYANTuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYANTuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYANTuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:50:00 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:42961 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbYANTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:49:59 -0500
Date: Mon, 14 Jan 2008 20:49:57 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt1
Message-ID: <20080114194957.GQ27137@pengutronix.de>
References: <1200250801.9190.7.camel@localhost.localdomain> <20080113202522.GD27137@pengutronix.de> <Pine.LNX.4.58.0801131544430.10093@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801131544430.10093@gandalf.stny.rr.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 20:45:22 up 123 days, 23:35, 21 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 10.1.1.3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 03:48:33PM -0500, Steven Rostedt wrote:
> > Works fine on phyCORE-MPC5200B-tiny, here are the latest results:
> > http://www.pengutronix.de/oselas/realtime/results/20080113-1/
>
> That doesn't look too bad. Or is over a 100us not good for that box?

I think it's ok. However, Wolfgang still sees strange long delays on his
Icecube, so it was mainly for comparism.

> Also is it SMP?

Nope, UP. This one:

http://www.phytec.de/phytec/32-bit_module/phycore-mpc5200b-tiny.html

The CPU is basically a 603e core plus peripherals.

> Yeah, I didn't make any attempt to fix latency_tracing for PPC on this
> release. I expected as much. I do have a couple of PPC boxes that I can
> play with, and I'll see if I can get that working too before -rt2. But I
> want to get a stable x86 release out fast.

Yup, great, thanks!

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

