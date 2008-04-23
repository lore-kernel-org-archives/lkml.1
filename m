Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYDWKAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYDWKAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYDWJxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36971 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237AbYDWJxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:07 -0400
Date: Wed, 23 Apr 2008 12:52:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tony Jones <tonyj@suse.de>, aacraid@adaptec.com,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make aacraid/linit.c:aac_show_serial_number() static
Message-ID: <20080423095228.GJ28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aac_show_serial_number() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a39f863838d5676ccb3dae2b1aac14a6ae6e33bc diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index c109f63..1d2dc5a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -854,8 +854,8 @@ static ssize_t aac_show_bios_version(struct device *device,
 	return len;
 }
 
-ssize_t aac_show_serial_number(struct device *device,
-			       struct device_attribute *attr, char *buf)
+static ssize_t aac_show_serial_number(struct device *device,
+				      struct device_attribute *attr, char *buf)
 {
 	struct aac_dev *dev = (struct aac_dev*)class_to_shost(device)->hostdata;
 	int len = 0;

