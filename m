Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZGXTPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZGXTPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZGXTPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:15:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:24398 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZGXTPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=S63ZSF88fnA6+LJ+yvw/gAAKOKcCfRQ1aGt0lwMx/zrJzN6Dfdc4WmXNo/rZ2gJ6pw
         BTyl1PjjbkaqnpcfMBSOv721oRuTSFrqqrXsUqL8O+acXPe8or2vU6MwpU8n0DN12En3
         NNkfm8ajivQ2+ibaGCDHyyV1CA2LYOTAkH02U=
MIME-Version: 1.0
Date: Sat, 25 Jul 2009 03:15:05 +0800
Message-ID: <86bb1aef0907241215v3d693c6n40721684d16c4740@mail.gmail.com>
Subject: [PATCH] amd64_edac: to read the right f2maskoffset reg
From: wan wei <onewayforever@gmail.com>
To: dougthompson@xmission.com, borislav.petkov@amd.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn, onewayforever@gmail.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 858fe60..24964c1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -970,7 +970,7 @@ static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
        }

        for (cs = 0; cs < pvt->num_dcsm; cs++) {
-               reg = K8_DCSB0 + (cs * 4);
+               reg = K8_DCSM0 + (cs * 4);
                err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
                                        &pvt->dcsm0[cs]);
                if (unlikely(err))
-- 
1.4.4.2
