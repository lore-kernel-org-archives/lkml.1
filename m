Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYBSAWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYBSAWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbYBSAWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:22:35 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:22775 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYBSAWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:22:34 -0500
Date: Mon, 18 Feb 2008 16:22:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] documentation: fix firmware_sample_firmware_class to build
Message-Id: <20080218162216.ee1501fd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix firmware_sample_firmware_class module to build without error.
sysfs.h already has the function prototypes and has them correctly.

Documentation/firmware_class/firmware_sample_firmware_class.c:37: error: conflicting types for 'sysfs_remove_bin_file'
include/linux/sysfs.h:100: error: previous declaration of 'sysfs_remove_bin_file' was here

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/firmware_class/firmware_sample_firmware_class.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2625-rc2-docsrc.orig/Documentation/firmware_class/firmware_sample_firmware_class.c
+++ linux-2625-rc2-docsrc/Documentation/firmware_class/firmware_sample_firmware_class.c
@@ -33,9 +33,6 @@ struct class_device_attribute *to_class_
 	return container_of(_attr,struct class_device_attribute,attr);
 }
 
-int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr);
-int sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr);
-
 struct firmware_priv {
 	char fw_id[FIRMWARE_NAME_MAX];
 	s32 loading:2;
