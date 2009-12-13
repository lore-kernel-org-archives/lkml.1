Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZLNAMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZLNAMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZLNAMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:12:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbZLMX57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:59 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, viro@zeniv.linux.org.uk, jeffm@suse.com,
       torvalds@linux-foundation.org
Subject: [PATCH 1/2] Constify struct item_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:49 +0100
Message-Id: <bd7230a64d3686cfabccfaad63d10b0e4d28b88b.1260662998.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662998.git.re.emese@gmail.com>
References: <cover.1260662998.git.re.emese@gmail.com>
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
---
 fs/reiserfs/item_ops.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/reiserfs/item_ops.c b/fs/reiserfs/item_ops.c
index 72cb1cc..d0e3181 100644
--- a/fs/reiserfs/item_ops.c
+++ b/fs/reiserfs/item_ops.c
@@ -102,7 +102,7 @@ static void sd_print_vi(struct virtual_item *vi)
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
-static struct item_operations stat_data_ops = {
+static const struct item_operations stat_data_ops = {
 	.bytes_number = sd_bytes_number,
 	.decrement_key = sd_decrement_key,
 	.is_left_mergeable = sd_is_left_mergeable,
@@ -196,7 +196,7 @@ static void direct_print_vi(struct virtual_item *vi)
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
-static struct item_operations direct_ops = {
+static const struct item_operations direct_ops = {
 	.bytes_number = direct_bytes_number,
 	.decrement_key = direct_decrement_key,
 	.is_left_mergeable = direct_is_left_mergeable,
@@ -341,7 +341,7 @@ static void indirect_print_vi(struct virtual_item *vi)
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
-static struct item_operations indirect_ops = {
+static const struct item_operations indirect_ops = {
 	.bytes_number = indirect_bytes_number,
 	.decrement_key = indirect_decrement_key,
 	.is_left_mergeable = indirect_is_left_mergeable,
@@ -628,7 +628,7 @@ static void direntry_print_vi(struct virtual_item *vi)
 	printk("\n");
 }
 
-static struct item_operations direntry_ops = {
+static const struct item_operations direntry_ops = {
 	.bytes_number = direntry_bytes_number,
 	.decrement_key = direntry_decrement_key,
 	.is_left_mergeable = direntry_is_left_mergeable,
@@ -724,7 +724,7 @@ static void errcatch_print_vi(struct virtual_item *vi)
 			 "Invalid item type observed, run fsck ASAP");
 }
 
-static struct item_operations errcatch_ops = {
+static const struct item_operations errcatch_ops = {
 	errcatch_bytes_number,
 	errcatch_decrement_key,
 	errcatch_is_left_mergeable,
@@ -746,7 +746,7 @@ static struct item_operations errcatch_ops = {
 #error Item types must use disk-format assigned values.
 #endif
 
-struct item_operations *item_ops[TYPE_ANY + 1] = {
+const struct item_operations * const item_ops[TYPE_ANY + 1] = {
 	&stat_data_ops,
 	&indirect_ops,
 	&direct_ops,
-- 
1.6.5.3

