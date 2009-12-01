Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbZLABbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbZLABbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 20:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZLABbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 20:31:09 -0500
Received: from wacom-nt10.wacom.com ([204.119.25.43]:30245 "EHLO
	wacom-nt10.wacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZLABbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:31:08 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] serial/8250_pnp.c: add new Wacom devices
Date: Mon, 30 Nov 2009 17:31:14 -0800
Message-ID: <6753EB6004AFF34FAA275742C104F952016A12D0@wacom-nt10.wacom.com>
In-Reply-To: <6753EB6004AFF34FAA275742C104F952BDD5E0@wacom-nt10.wacom.com>
References: <6753EB6004AFF34FAA275742C104F952BDD5E0@wacom-nt10.wacom.com>
From: "Ping Cheng" <pingc@wacom.com>
To: <linux-kernel@vger.kernel.org>
Cc: <pinglinux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend. I forgot to update the subject line last time. I am
not in the mailing list. Please cc me with your reply.  Thank you.


Add 10 serial Wacom Tablet PC devices. In fact, 
The last 3 bytes of WACF### are all reserved 
for Wacom serial OEMs.

Signed-off-by: Ping Cheng <pingc@wacom.com>
---
 drivers/serial/8250_pnp.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index d71dfe3..898c0f0 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -337,6 +337,15 @@ static const struct pnp_device_id pnp_dev_table[] =
{
 	{       "WACF00A",              0       },
 	{       "WACF00B",              0       },
 	{       "WACF00C",              0       },
+	{       "WACF00D",              0       },
+	{       "WACF00E",              0       },
+	{       "WACF00F",              0       },
+	{       "WACF010",              0       },
+	{       "WACF011",              0       },
+	{       "WACF012",              0       },
+	{       "WACF013",              0       },
+	{       "WACF014",              0       },
+	{       "WACF015",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
@@ -354,6 +363,8 @@ static const struct pnp_device_id pnp_dev_table[] =
{
 	{	"FUJ02E5",		0	},
 	/* Fujitsu P-series tablet PC device */
 	{	"FUJ02E6",		0	},
+	/* Fujitsu Wacom Tablet PC device */
+	{	"FUJ02E7",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a
FUJ02E6 in
 	 * disguise)
-- 
1.6.5.2

