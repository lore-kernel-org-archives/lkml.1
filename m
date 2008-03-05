Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbYCEHlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbYCEHlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYCEHlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:41:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:60391 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbYCEHlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EZpNgyYujlB5RDRBs8kSxZ7zm5A+6QDOsm9PvYI3KWpas3EX07rnM4R+RfBMoVft5Cs5tN57lJjGxybeOUO4yE5lmFlleif7HUHXnOzjbyOSc2vXw60qjX7ZB6ljM0SZooDoTrmlwPE8vk/P9DT2/PN0HHlZA3NI8Y9rmz1F334=
Subject: [PATCH 1/3] scsi: st.c make class attributes static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 23:40:55 -0800
Message-Id: <1204702855.17484.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warnings:
drivers/scsi/st.c:4299:1: warning: symbol 'class_device_attr_defined' was not declared. Should it be static?
drivers/scsi/st.c:4310:1: warning: symbol 'class_device_attr_default_blksize' was not declared. Should it be static?
drivers/scsi/st.c:4323:1: warning: symbol 'class_device_attr_default_density' was not declared. Should it be static?
drivers/scsi/st.c:4334:1: warning: symbol 'class_device_attr_default_compression' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/st.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0a52d9d..9778ab7 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4296,7 +4296,7 @@ static ssize_t st_defined_show(struct class_device *class_dev, char *buf)
 	return l;
 }
 
-CLASS_DEVICE_ATTR(defined, S_IRUGO, st_defined_show, NULL);
+static CLASS_DEVICE_ATTR(defined, S_IRUGO, st_defined_show, NULL);
 
 static ssize_t st_defblk_show(struct class_device *class_dev, char *buf)
 {
@@ -4307,7 +4307,7 @@ static ssize_t st_defblk_show(struct class_device *class_dev, char *buf)
 	return l;
 }
 
-CLASS_DEVICE_ATTR(default_blksize, S_IRUGO, st_defblk_show, NULL);
+static CLASS_DEVICE_ATTR(default_blksize, S_IRUGO, st_defblk_show, NULL);
 
 static ssize_t st_defdensity_show(struct class_device *class_dev, char *buf)
 {
@@ -4320,7 +4320,7 @@ static ssize_t st_defdensity_show(struct class_device *class_dev, char *buf)
 	return l;
 }
 
-CLASS_DEVICE_ATTR(default_density, S_IRUGO, st_defdensity_show, NULL);
+static CLASS_DEVICE_ATTR(default_density, S_IRUGO, st_defdensity_show, NULL);
 
 static ssize_t st_defcompression_show(struct class_device *class_dev, char *buf)
 {
@@ -4331,7 +4331,7 @@ static ssize_t st_defcompression_show(struct class_device *class_dev, char *buf)
 	return l;
 }
 
-CLASS_DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
+static CLASS_DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
 
 static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 {
-- 
1.5.4.GIT


