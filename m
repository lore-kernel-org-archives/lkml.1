Return-Path: <linux-kernel-owner+w=401wt.eu-S1760452AbYEES1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452AbYEES1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbYEESZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:25:05 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54869 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760193AbYEESZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:25:02 -0400
Date: Mon, 5 May 2008 21:23:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [2.6 patch] make struct scsi_shost_attr_group static
Message-ID: <20080505182354.GL17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct scsi_shost_attr_group 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4c2ca34e6b45468b0859ac38f936d73d45b66e8f diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 049103f..8236930 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -266,7 +266,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
