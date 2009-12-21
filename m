Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZLUQkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZLUQkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZLUQkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:40:10 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35107 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZLUQkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:40:09 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] Driver core: export platform_device_register_data as a GPL symbol
Date: Mon, 21 Dec 2009 11:41:08 -0500
Message-Id: <1261413668-30145-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

This allows MFD's to register/bind drivers for their sub devices while
still being compiled as a module.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/base/platform.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 9d2ee25..58efaf2 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -441,6 +441,7 @@ error:
 	platform_device_put(pdev);
 	return ERR_PTR(retval);
 }
+EXPORT_SYMBOL_GPL(platform_device_register_data);
 
 static int platform_drv_probe(struct device *_dev)
 {
-- 
1.6.5.4

