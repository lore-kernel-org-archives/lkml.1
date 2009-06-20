Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZFTBAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZFTBAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZFTBAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:00:09 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:6727 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754847AbZFTBAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:00:08 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/mtd/mtdcore.c: don't export local symbols
Date: Fri, 19 Jun 2009 18:00:13 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191800.13129.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make mtd_group and mtd_groups static since they are only used in
this file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index bccb4b1..a8a810c 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -187,11 +187,11 @@ static struct attribute *mtd_attrs[] = {
 	NULL,
 };
 
-struct attribute_group mtd_group = {
+static struct attribute_group mtd_group = {
 	.attrs		= mtd_attrs,
 };
 
-struct attribute_group *mtd_groups[] = {
+static struct attribute_group *mtd_groups[] = {
 	&mtd_group,
 	NULL,
 };
