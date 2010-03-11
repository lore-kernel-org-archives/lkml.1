Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab0CKSHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:07:02 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:43634 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab0CKSGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:06:38 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 30/37] drivers/cdrom: use .of_node instead of
	.archdata.of_node in struct device
To: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Date: Thu, 11 Mar 2010 11:06:33 -0700
Message-ID: <20100311180633.4824.27717.stgit@angua>
In-Reply-To: <20100311174830.4824.19820.stgit@angua>
References: <20100311174830.4824.19820.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.archdata.node is being removed from Microblaze, SPARC and PowerPC.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/cdrom/viocd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index cc435be..451cd70 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -567,7 +567,7 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	struct disk_info *d;
 	struct cdrom_device_info *c;
 	struct request_queue *q;
-	struct device_node *node = vdev->dev.archdata.of_node;
+	struct device_node *node = vdev->dev.of_node;
 
 	deviceno = vdev->unit_address;
 	if (deviceno >= VIOCD_MAX_CD)

