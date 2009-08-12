Return-Path: <linux-kernel-owner+w=401wt.eu-S1751543AbZHLVdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbZHLVdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZHLVdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:33:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50692 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZHLVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:33:49 -0400
Date: Wed, 12 Aug 2009 23:33:48 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
Message-ID: <20090812213348.GY13320@pengutronix.de>
References: <20090805171513.GA10443@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090805171513.GA10443@kroah.com>
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
X-Uptime: 23:29:39 up 7 days,  8:48, 11 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 10:15:13AM -0700, Greg KH wrote:
> Here's the devtmpfs patch again.

As an embedded distro maintainer, I'd really like such an approach. With
ptxdist, we can today build the complete rootfs for an embedded system
without root permissions - just if we want to nfs-root boot the boards
during development, it doesn't work, because you have to create
/dev/console, /dev/null and /dev/zero and that works only for root.

On slow embedded systems (i.e. ARM 200 MHz), note that boot times are
often much slower than on full-blown x86. So any speed improvement is
welcome here as well.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
