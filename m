Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbYCEHlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbYCEHlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYCEHlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:41:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:60391 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbYCEHlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T1nDUqsHr28GJVB4vmK7Ul8Tt6JzgPJRWrvUbEIAw9SwneCafv+SzRlntdNdAUJS/5ukHw6PXBBC+uVA8QAbbUKOPXhcriMgu6NQ66Ngu3/whR9nUOQujJMymRlchSU2b+gRgiFIiKBcyrb5vkyF3JmwHQU5AW2kaGeKdpqxtVg=
Subject: [PATCH 2/3] scsi: osst.c make class attributes static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 23:40:56 -0800
Message-Id: <1204702856.17484.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warnings:
drivers/scsi/osst.c:5604:1: warning: symbol 'class_device_attr_ADR_rev' was not declared. Should it be static?
drivers/scsi/osst.c:5616:1: warning: symbol 'class_device_attr_media_version' was not declared. Should it be static?
drivers/scsi/osst.c:5628:1: warning: symbol 'class_device_attr_capacity' was not declared. Should it be static?
drivers/scsi/osst.c:5640:1: warning: symbol 'class_device_attr_BOT_frame' was not declared. Should it be static?
drivers/scsi/osst.c:5652:1: warning: symbol 'class_device_attr_EOD_frame' was not declared. Should it be static?
drivers/scsi/osst.c:5664:1: warning: symbol 'class_device_attr_file_count' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/osst.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index abef704..a5d5a60 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5601,7 +5601,7 @@ static ssize_t osst_adr_rev_show(struct class_device *class_dev, char *buf)
 	return l;
 }
 
-CLASS_DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
+static CLASS_DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
 
 static ssize_t osst_linux_media_version_show(struct class_device *class_dev, char *buf)
 {
@@ -5613,7 +5613,7 @@ static ssize_t osst_linux_media_version_show(struct class_device *class_dev, cha
 	return l;
 }
 
-CLASS_DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
+static CLASS_DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
 
 static ssize_t osst_capacity_show(struct class_device *class_dev, char *buf)
 {
@@ -5625,7 +5625,7 @@ static ssize_t osst_capacity_show(struct class_device *class_dev, char *buf)
 	return l;
 }
 
-CLASS_DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
+static CLASS_DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
 
 static ssize_t osst_first_data_ppos_show(struct class_device *class_dev, char *buf)
 {
@@ -5637,7 +5637,7 @@ static ssize_t osst_first_data_ppos_show(struct class_device *class_dev, char *b
 	return l;
 }
 
-CLASS_DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
+static CLASS_DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
 
 static ssize_t osst_eod_frame_ppos_show(struct class_device *class_dev, char *buf)
 {
@@ -5649,7 +5649,7 @@ static ssize_t osst_eod_frame_ppos_show(struct class_device *class_dev, char *bu
 	return l;
 }
 
-CLASS_DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
+static CLASS_DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
 
 static ssize_t osst_filemark_cnt_show(struct class_device *class_dev, char *buf)
 {
@@ -5661,7 +5661,7 @@ static ssize_t osst_filemark_cnt_show(struct class_device *class_dev, char *buf)
 	return l;
 }
 
-CLASS_DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
+static CLASS_DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
 
 static struct class *osst_sysfs_class;
 
-- 
1.5.4.GIT


