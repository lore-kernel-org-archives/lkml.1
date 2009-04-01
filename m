Return-Path: <linux-kernel-owner+w=401wt.eu-S1765115AbZDAOE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765115AbZDAOE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbZDAOEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:04:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36479 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763155AbZDAOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:04:15 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/24] serial: Update PNP IDs
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:04:46 +0100
Message-ID: <20090401140441.22882.35585.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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

