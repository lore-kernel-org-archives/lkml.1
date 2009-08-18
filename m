Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbZHRKyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbZHRKyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZHRKyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:54:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60652 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbZHRKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:54:23 -0400
Date: Tue, 18 Aug 2009 12:53:28 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
       Johannes Stezenbach <js@sig21.net>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090818105328.GP29655@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com> <20090814204305.GA31727@pengutronix.de> <20090815103532.GA5596@sig21.net> <4A8A7D38.5020201@gmail.com> <20090818102136.GN29655@pengutronix.de> <81b0412b0908180334u51fd957dh36f2a4946dffbb0b@mail.gmail.com> <20090818104410.GO29655@pengutronix.de> <81b0412b0908180348n75af1113wb380919eaeaaf29b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <81b0412b0908180348n75af1113wb380919eaeaaf29b@mail.gmail.com>
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
X-Uptime: 12:51:02 up 12 days, 22:10, 51 users,  load average: 9.01, 9.08,
	6.90
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 12:48:50PM +0200, Alex Riesen wrote:
> But many of the problems you described and suggested solutions
> point at userspace, right? (like pre-defined static /dev, mdev script,
> or using of specially designed rootfs)

Yes, right. But even there, mdev is more in the "embedded special"
league than udev, for example, and highly specialized read-only root
filesystems as well.

rsc 
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
