Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZBPQ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZBPQ71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZBPQ7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:59:17 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53739 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZBPQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:59:16 -0500
Date: Mon, 16 Feb 2009 16:59:12 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Subject: [PATCH] serial: update PNP IDs
Message-ID: <20090216165912.GA8356@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new Wacom device IDs to the 8250_pnp serial driver, to support autoconfig
on some newer tablet PCs. Also add a comment to clarify that the FUJ02E6
device is a custom protocol, not a Wacom tablet.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index bbcfc26..d71dfe3 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -333,6 +333,10 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{       "WACF006",              0       },
 	{       "WACF007",              0       },
 	{       "WACF008",              0       },
+	{       "WACF009",              0       },
+	{       "WACF00A",              0       },
+	{       "WACF00B",              0       },
+	{       "WACF00C",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
@@ -346,8 +350,9 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{       "FUJ02B8",              0 },
 	{       "FUJ02B9",              0 },
 	{       "FUJ02BC",              0 },
-	/* Fujitsu Wacom Tablet PC devices */
+	/* Fujitsu Wacom Tablet PC device */
 	{	"FUJ02E5",		0	},
+	/* Fujitsu P-series tablet PC device */
 	{	"FUJ02E6",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in

-- 
Matthew Garrett | mjg59@srcf.ucam.org
