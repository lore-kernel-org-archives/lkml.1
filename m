Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZCBAA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZCBAA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbZCBAAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:00:48 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:41406 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbZCBAAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:00:47 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH] IOMMU: use ANSI style function declaration for 'iommu_found'
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Mar 2009 01:00:41 +0100
Message-ID: <20090302000010.14884.9400.stgit@localhost.localdomain>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  drivers/base/iommu.c:34:18: warning: non-ANSI function declaration of function 'iommu_found'

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/base/iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index 5e039d4..c2d1eed 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -31,7 +31,7 @@ void register_iommu(struct iommu_ops *ops)
 	iommu_ops = ops;
 }
 
-bool iommu_found()
+bool iommu_found(void)
 {
 	return iommu_ops != NULL;
 }

