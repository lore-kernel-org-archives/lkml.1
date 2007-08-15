Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXHOX6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXHOX6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXHOX62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:58:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbXHOX61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:58:27 -0400
Date: Wed, 15 Aug 2007 19:58:25 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rolandd@cisco.com
Subject: drivers/infiniband/mlx/mad.c misplaced ;
Message-ID: <20070815235825.GB17004@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rolandd@cisco.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 3330917..0ed02b7 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -109,7 +109,7 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 			   in_modifier, op_modifier,
 			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C);
 
-	if (!err);
+	if (!err)
 		memcpy(response_mad, outmailbox->buf, 256);
 
 	mlx4_free_cmd_mailbox(dev->dev, inmailbox);

-- 
http://www.codemonkey.org.uk
