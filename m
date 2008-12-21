Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbYLUW2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbYLUW2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 17:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYLUW2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 17:28:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42204 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYLUW2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 17:28:23 -0500
Date: Sun, 21 Dec 2008 23:27:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] arch/arm/plat-mxc: Add local_irq_restore in error
	handling code
Message-ID: <20081221222758.GB1614@pengutronix.de>
Mail-Followup-To: Julia Lawall <julia@diku.dk>, kernel@pengutronix.de,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0812212153570.3635@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812212153570.3635@ask.diku.dk>
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
X-Uptime: 23:20:56 up 8 days,  2:48,  9 users,  load average: 0.02, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 21, 2008 at 09:54:23PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> There is a call to local_irq_restore in the normal exit case, so it would
> seem that there should be one on an error return as well.

Yes, that's correct. Thanks for the patch. A fix for this is already
scheduled upstream though.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
