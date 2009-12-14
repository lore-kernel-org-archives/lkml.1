Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZLNAAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZLNAAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbZLMX6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbZLMX6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:41 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, shemminger@vyatta.com,
       torvalds@linux-foundation.org
Subject: [PATCH 02/25] Constify struct sysfs_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:09 +0100
Message-Id: <6ae78be1c7c12171c65134cb2b76ea046b916199.1260663004.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663004.git.re.emese@gmail.com>
References: <cover.1260663004.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
---
 fs/btrfs/sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a240b6f..4ce16ef 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -164,12 +164,12 @@ static void btrfs_root_release(struct kobject *kobj)
 	complete(&root->kobj_unregister);
 }
 
-static struct sysfs_ops btrfs_super_attr_ops = {
+static const struct sysfs_ops btrfs_super_attr_ops = {
 	.show	= btrfs_super_attr_show,
 	.store	= btrfs_super_attr_store,
 };
 
-static struct sysfs_ops btrfs_root_attr_ops = {
+static const struct sysfs_ops btrfs_root_attr_ops = {
 	.show	= btrfs_root_attr_show,
 	.store	= btrfs_root_attr_store,
 };
-- 
1.6.5.3

