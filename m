Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZGLWrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZGLWrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZGLWqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:33 -0400
Received: from kroah.org ([198.145.64.141]:33501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZGLWqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/9] Driver Core: remove BUS_ID_SIZE
Date: Sun, 12 Jul 2009 15:46:01 -0700
Message-Id: <1247438766-17266-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

The name size limit is gone from the driver-core, this is
the removal of the last left-over.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index ed4e39f..aebb810 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -25,8 +25,6 @@
 #include <asm/atomic.h>
 #include <asm/device.h>
 
-#define BUS_ID_SIZE		20
-
 struct device;
 struct device_private;
 struct device_driver;
-- 
1.6.3.2

