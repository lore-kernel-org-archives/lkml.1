Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZDFPcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZDFPcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbZDFPc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:32:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46783 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754049AbZDFPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:32:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/27] serial: Update PNP IDs
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:32:01 +0100
Message-ID: <20090406163159.12934.75961.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg59@srcf.ucam.org>

Add new Wacom device IDs to the 8250_pnp serial driver, to support
autoconfig on some newer tablet PCs.  Also add a comment to clarify that
the FUJ02E6 device is a custom protocol, not a Wacom tablet.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@etchedpixels.co.uk>
---

 drivers/serial/8250_pnp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index 6db9f13..d71dfe3 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -334,6 +334,9 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{       "WACF007",              0       },
 	{       "WACF008",              0       },
 	{       "WACF009",              0       },
+	{       "WACF00A",              0       },
+	{       "WACF00B",              0       },
+	{       "WACF00C",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
@@ -347,8 +350,9 @@ static const struct pnp_device_id pnp_dev_table[] = {
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

