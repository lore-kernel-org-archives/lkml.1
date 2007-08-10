Return-Path: <linux-kernel-owner+w=401wt.eu-S934751AbXHJM2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751AbXHJM2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757647AbXHJM2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:28:43 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:50510 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXHJM2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:28:42 -0400
Message-ID: <46BC59B6.4060301@csr.com>
Date: Fri, 10 Aug 2007 13:27:34 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pierre Ossman <drzeus-list@drzeus.cx>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: sdio: set host bus width
References: <46BC58E8.50300@csr.com>
In-Reply-To: <46BC58E8.50300@csr.com>
Content-Type: multipart/mixed;
 boundary="------------030108050705020908070903"
X-OriginalArrivalTime: 10 Aug 2007 12:27:47.0431 (UTC) FILETIME=[DC0D6770:01C7DB49]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030108050705020908070903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------030108050705020908070903
Content-Type: text/x-patch;
 name="sdio-set-host-bus-width.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-set-host-bus-width.patch"

sdio: set host bus width

Need to set the bus width used by the host when enabling wide (4 bit) mode.

Signed-of-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/drivers/mmc/core/sdio.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio.c	2007-08-10 01:15:54.000000000 +0100
+++ mmc/drivers/mmc/core/sdio.c	2007-08-10 01:16:05.000000000 +0100
@@ -159,6 +159,8 @@
 	if (ret)
 		return ret;
 
+	mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
+
 	return 0;
 }
 

--------------030108050705020908070903--
