Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYIMGdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYIMGdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 02:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYIMGdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 02:33:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:52686 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbYIMGdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 02:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=uAO3X0zf3SGPwncRT/reEPXNz3E67g2Z9iB1bEm/UpsyuNdLnvx/uNKl6dSpceOJyI
         iBN5K1jph3n0+sDcWRWBkTjasVJl0SDZcpfZmoETw4CRMHdA889jzsbk5HlFlyqm2h7w
         CCQ6wwP4pGagroU8wfOiXpwDb5Le2ZDxZQDno=
Message-ID: <48CB5E9F.9060109@gmail.com>
Date: Fri, 12 Sep 2008 23:33:03 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [MTD] physmap.c: Add #endif comments
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding comments to a few of the less painfully-obvious #endifs.

Signed-off-by: Zev Weiss <zevweiss@gmail.com>
---
  drivers/mtd/maps/physmap.c |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 6fba0d4..49e2039 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -244,7 +244,7 @@ static void physmap_flash_shutdown(struct platform_device *dev)
  #define physmap_flash_suspend NULL
  #define physmap_flash_resume NULL
  #define physmap_flash_shutdown NULL
-#endif
+#endif /* CONFIG_PM */

  static struct platform_driver physmap_flash_driver = {
  	.probe		= physmap_flash_probe,
@@ -302,8 +302,8 @@ void physmap_set_partitions(struct mtd_partition *parts, int
num_parts)
  	physmap_flash_data.nr_parts = num_parts;
  	physmap_flash_data.parts = parts;
  }
-#endif
-#endif
+#endif /* CONFIG_MTD_PARTITIONS */
+#endif /* PHYSMAP_COMPAT */

  static int __init physmap_init(void)
  {
-- 
1.5.4.1


