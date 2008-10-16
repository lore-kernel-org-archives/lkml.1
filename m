Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYJPRVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYJPRVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYJPROY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:24 -0400
Received: from kroah.org ([198.145.64.141]:46956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756137AbYJPROV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/46] device create: remove device_create_drvdata
Date: Thu, 16 Oct 2008 10:10:16 -0700
Message-Id: <1224177047-11859-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the tree is cleaned up, device_create_drvdata can be safely
removed.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 246937c..60f6456 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -502,7 +502,6 @@ extern struct device *device_create(struct class *cls, struct device *parent,
 				    dev_t devt, void *drvdata,
 				    const char *fmt, ...)
 				    __attribute__((format(printf, 5, 6)));
-#define device_create_drvdata	device_create
 extern void device_destroy(struct class *cls, dev_t devt);
 
 /*
-- 
1.6.0.2

