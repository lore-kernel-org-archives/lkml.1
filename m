Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZKKQuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZKKQuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbZKKQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:49:57 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:27317 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087AbZKKQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:49:52 -0500
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/17] hpsa: Make hpsa_sdev_attrs static
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
Date: Wed, 11 Nov 2009 10:51:19 -0600
Message-ID: <20091111165119.17754.81784.stgit@beardog.cce.hp.com>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpsa: Make hpsa_sdev_attrs static

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index dfef62d..f893a53 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -155,7 +155,7 @@ DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
 DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
-struct device_attribute *hpsa_sdev_attrs[] = {
+static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
 	&dev_attr_lunid,
 	&dev_attr_unique_id,

