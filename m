Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZI2BY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZI2BY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 21:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZI2BY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 21:24:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:55070 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753817AbZI2BYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 21:24:55 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/ooIBSUTroVHDuDvUBwUdaH9caUJ7tGVZzkaWO5c
	AAlygOEG53w86b
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] hid: adding __init/__exit macros to twinhan.c
Date: Tue, 29 Sep 2009 03:24:55 +0200
User-Agent: KMail/1.9.10
Cc: Bruno Premont <bonbons@linux-vserver.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909290324.56042.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of the twinhan driver in hid.

Jiri, I guess this time you can decide wether it's the hid or the trivial 
tree ;) - thanks jiri for all your patience and work!

linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/hid/hid-twinhan.c b/drivers/hid/hid-twinhan.c
index b05f602..c40afc5 100644
--- a/drivers/hid/hid-twinhan.c
+++ b/drivers/hid/hid-twinhan.c
@@ -132,12 +132,12 @@ static struct hid_driver twinhan_driver = {
 	.input_mapping = twinhan_input_mapping,
 };
 
-static int twinhan_init(void)
+static int __init twinhan_init(void)
 {
 	return hid_register_driver(&twinhan_driver);
 }
 
-static void twinhan_exit(void)
+static void __exit twinhan_exit(void)
 {
 	hid_unregister_driver(&twinhan_driver);
 }
