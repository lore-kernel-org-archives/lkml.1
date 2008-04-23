Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYDWJ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYDWJ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbYDWJxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:05 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59511 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYDWJxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:04 -0400
Date: Wed, 23 Apr 2008 12:52:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tony Jones <tonyj@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make scsi_sysfs.c:dev_attr_hstate static
Message-ID: <20080423095224.GI28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global dev_attr_hstate static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
3cf42091b042f5cf957b81c4558d2aa0fd3ba741 diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 67bb20e..84aad59 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -192,7 +192,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t

