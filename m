Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYHAHSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYHAHSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYHAHR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:17:59 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:42737 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbYHAHR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:17:59 -0400
Date: Fri, 1 Aug 2008 09:17:27 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Ulrich Teichert <krypton@ulrich-teichert.org>,
       Tim Bird <tim.bird@am.sony.com>, David Miller <davem@davemloft.net>,
       dwmw2@infradead.org, torvalds@linux-foundation.org,
       thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
	features
Message-ID: <20080801071727.GI8254@pengutronix.de>
References: <200807311850.m6VIoqCE015883@arbas.nms.ulrich-teichert.org> <1217533588.2328.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1217533588.2328.1.camel@localhost.localdomain>
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
X-Uptime: 09:13:21 up 30 days, 19:56, 13 users,  load average: 0.00, 0.07,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 10.1.0.65
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 03:46:28PM -0400, Josh Boyer wrote:
> > I do not think of NTP as desktop or server application, but that's
> > probably just me,
>
> No, it's not just you. NTP is useful in cases where things do care
> about time but hardware designers were too cheap to put an RTC on the
> board.

Yes, we also have such customer systems, i.e. one which is used in a
Telemetry application where you can have hundrets of PXA270 data
concentrators that collect data from FPGAs and push them to a PC via
ethernet. As the system does not work without the PC, the hardware
designers decided that they can save hundrets of RTCs.

Or another autonomous data collection system where only one system of
several tens has an RTC...

We used chrony in these cases, as the standard ntputils seem to be
optimized for scenarios where you have permanent network connection,
which is often not the case in embedded applications.

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

