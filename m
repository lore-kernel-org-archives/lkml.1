Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXJJJCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXJJJCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbXJJJCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:02:44 -0400
Received: from isis45.plusserver.de ([217.172.174.164]:54138 "EHLO
	isis45.plusserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbXJJJCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:02:43 -0400
X-Greylist: delayed 3894 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 05:02:43 EDT
Date: Wed, 10 Oct 2007 09:55:58 +0200
From: Maik Broemme <mbroemme@plusserver.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Added support for Wacom WACF007 and WACF008 to serial pnp
	driver.
Message-ID: <20071010075558.GC10600@bart.intergenia.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
X-Message-Flag: Outlook : A program to spread viri, but it can do mail too.
X-Operating-System: Linux bart 2.6.23-rc9 
Organization: PlusServer GmbH
X-PGP-Key-FingerPrint: 109D 0AC6 86CF 06BD 4890  17B0 8FB9 9971 4EEB 31F1
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam-Score: -103.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

notebook manufacturer seems to built a newer Wacom pen enabled tablet to
recent tablet pcs which are not recognized by the serial pnp driver.

Attached is a patch which makes the newer Wacom WACF007 and WACF008
tablets useable with the serial driver. The device is fully compatible
with it.

This is a resent of my mail two weeks ago to 'linux-serial' :)

--Maik

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.23-rc8-newer-wacom.patch"

diff -Nur linux-2.6.23-rc8/drivers/serial/8250_pnp.c linux-2.6.23-rc8-newer-wacom/drivers/serial/8250_pnp.c
--- linux-2.6.23-rc8/drivers/serial/8250_pnp.c	2007-09-28 17:14:07.000000000 +0200
+++ linux-2.6.23-rc8-newer-wacom/drivers/serial/8250_pnp.c	2007-09-28 17:09:45.000000000 +0200
@@ -327,6 +327,8 @@
 	{	"WACF004",		0	},
 	{	"WACF005",		0	},
 	{       "WACF006",              0       },
+	{       "WACF007",              0       },
+	{       "WACF008",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */

--7AUc2qLy4jB3hD7Z--
