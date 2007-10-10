Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXJJKRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXJJKRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXJJKRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:17:04 -0400
Received: from isis45.plusserver.de ([217.172.174.164]:47858 "EHLO
	isis45.plusserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbXJJKRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:17:03 -0400
Date: Wed, 10 Oct 2007 12:15:08 +0200
From: Maik Broemme <mbroemme@plusserver.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Added support for Wacom WACF007 and WACF008 to serial pnp
	driver.
Message-ID: <20071010101508.GG10600@bart.intergenia.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Message-Flag: Outlook : A program to spread viri, but it can do mail too.
X-Operating-System: Linux bart 2.6.23-rc9 
Organization: PlusServer GmbH
X-PGP-Key-FingerPrint: 109D 0AC6 86CF 06BD 4890  17B0 8FB9 9971 4EEB 31F1
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam-Score: -103.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

notebook manufacturer seems to built a newer Wacom pen enabled tablet to
recent tablet pcs which are not recognized by the serial pnp driver.

Attached is a patch which makes the newer Wacom WACF007 and WACF008
tablets useable with the serial driver. The device is fully compatible
with it.

Signed-off-by: Maik Broemme <mbroemme@plusserver.de>
---
diff -Nur linux-2.6.23-rc8/drivers/serial/8250_pnp.c linux-2.6.23-rc8-newer-wacom/drivers/serial/8250_pnp.c
--- linux-2.6.23-rc8/drivers/serial/8250_pnp.c  2007-09-28 17:14:07.000000000 +0200
+++ linux-2.6.23-rc8-newer-wacom/drivers/serial/8250_pnp.c      2007-09-28 17:09:45.000000000 +0200
@@ -327,6 +327,8 @@
	{       "WACF004",              0       },
	{       "WACF005",              0       },
	{       "WACF006",              0       },
+	{       "WACF007",              0       },
+	{       "WACF008",              0       },
	/* Compaq touchscreen */
	{       "FPI2002",              0 },
	/* Fujitsu Stylistic touchscreens */

--
Maik
