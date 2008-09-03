Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYICInx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYICInx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYICInq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:43:46 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:36286 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599AbYICInp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:43:45 -0400
Date: Wed, 3 Sep 2008 10:43:43 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [MMC] Multiple cards on one host
Message-ID: <20080903084343.GF4941@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
X-Uptime: 10:35:59 up 77 days, 18:10, 20 users,  load average: 0.46, 1.60,
	3.67
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 10.1.1.3
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a board (PXA based) which has two SD slots. It uses a gpio to
switch between the slots. In times when the MMC subsystem implemented
the bus topology our customer used this fact to connect the two slots on
a single host (although it was never intended to work with SD cards, it
seemed to work). Any idea how to implement this on recent kernels? I
thought about registering two hosts in pxamci.c, but this seems quite
hacky and I suppose I'll run into locking trouble.

Sascha

-- 
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9
