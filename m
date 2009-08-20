Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZHTVOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZHTVOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbZHTVOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:14:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:51409 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754400AbZHTVOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:14:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19dZo01tMFdDtQhi1OmUBjiB2hiNCw7XeFynTLKDZ
	qSsZsx1K/mcYLQ
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] char/hvc: adding __init macro to char/hvc_vio.c
Date: Thu, 20 Aug 2009 23:14:06 +0200
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>, Nicolas Palix <npalix@diku.dk>,
       Mike Frysinger <vapier@gentoo.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908202314.07443.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of char/hvc_vio.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version 2.6.31-rc6 - linus git tree, Do 20. Aug 22:26:06 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/char/hvc_vio.c b/drivers/char/hvc_vio.c
index c72b994..10be343 100644
--- a/drivers/char/hvc_vio.c
+++ b/drivers/char/hvc_vio.c
@@ -120,7 +120,7 @@ static struct vio_driver hvc_vio_driver = {
 	}
 };
 
-static int hvc_vio_init(void)
+static int __init hvc_vio_init(void)
 {
 	int rc;
 
@@ -134,7 +134,7 @@ static int hvc_vio_init(void)
 }
 module_init(hvc_vio_init); /* after drivers/char/hvc_console.c */
 
-static void hvc_vio_exit(void)
+static void __exit hvc_vio_exit(void)
 {
 	vio_unregister_driver(&hvc_vio_driver);
 }
