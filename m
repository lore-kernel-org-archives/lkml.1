Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617Ab0ASVB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0ASVB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592Ab0ASVBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:01:54 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9339 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755088Ab0ASVBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:01:52 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH] DocBook/mtdnand.tmpl: module_init() functions are static
Date: Tue, 19 Jan 2010 14:01:58 -0700
Cc: rdunlap@xenotime.net
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001191401.58643.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the example the module_init function should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>

---


diff --git a/Documentation/DocBook/mtdnand.tmpl b/Documentation/DocBook/mtdnand.tmpl
index 5e7d84b..60170a9 100644
--- a/Documentation/DocBook/mtdnand.tmpl
+++ b/Documentation/DocBook/mtdnand.tmpl
@@ -269,7 +269,7 @@ static void board_hwcontrol(struct mtd_info *mtd, int cmd)
 			information about the device.
 		</para>
 		<programlisting>
-int __init board_init (void)
+static int __init board_init (void)
 {
 	struct nand_chip *this;
 	int err = 0;
