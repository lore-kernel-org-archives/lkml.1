Return-Path: <linux-kernel-owner+w=401wt.eu-S1762439AbZE1AHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762439AbZE1AHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbZE1AHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:07:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZE1AHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:07:08 -0400
Date: Thu, 28 May 2009 02:07:07 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Scott Wood <scottwood@freescale.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528000707.GR6805@pengutronix.de>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> <20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> <20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4A1DD3A0.3010501@freescale.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 02:02:17 up 90 days,  9:44,  1 user,  load average: 0.03, 0.12,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 06:58:24PM -0500, Scott Wood wrote:
> Robert Schwebel wrote:
>> The oftree by design wants to be a complete hardware description. As
>> you mention above, there are cases where you *nevertheless* need
>> ad-hoc information about things *not* encoded into the device tree.
>>
>> This renders the whole concept ad absurdum. You need a machine number
>> again - and if you need that: why not stay with the ARM model, define
>> everything with platform data and avoid the whole thing?
>
> Because it's better to have a little platform specific code than a lot
> of it?

Until now, oftree has created more problems than it has solved for us.
The idea works fine for well-known things like memory maps and
interrupts. It works badly for corner cases, and embedded land is full
of it. The effort to get the oftree stuff right is often more than a
magnitude of order higher than the effort for the actual functionality.
That should be an alarm sign that something is wrong.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
