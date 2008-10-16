Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYJPRYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYJPRYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYJPROn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:43 -0400
Received: from kroah.org ([198.145.64.141]:46982 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755218AbYJPROk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/46] driver core: make struct platform_pm_ops static
Date: Thu, 16 Oct 2008 10:10:25 -0700
Message-Id: <1224177047-11859-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global struct platform_pm_ops static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3f94039..e621dad 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -862,7 +862,7 @@ static int platform_pm_restore_noirq(struct device *dev)
 
 #endif /* !CONFIG_HIBERNATION */
 
-struct pm_ext_ops platform_pm_ops = {
+static struct pm_ext_ops platform_pm_ops = {
 	.base = {
 		.prepare = platform_pm_prepare,
 		.complete = platform_pm_complete,
-- 
1.6.0.2

