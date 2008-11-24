Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYKXJJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYKXJJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYKXJJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:09:27 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:27859 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYKXJJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:09:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=CYZnMNifgAvuZenHvEcVVEsuf8lIWo48lbtl6EgfgjMoAp+45g7xrqxSytCbzfdnm6
         71GWjzdQM5G5Xc4ZqksbabgRhNuAYVEYjXkk8ZWc641R5ERJ3VmmxBeT29dTxbhP0o5K
         omZZ1/KFMPzz2Aq/RH2ftvb5ermogmkQ234Gg=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] block/blk-tag.c: cleanup kernel-doc
Date: Mon, 24 Nov 2008 17:09:14 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <492a6f43.054c6e0a.7df6.368b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no argument named @tags in blk_init_tags,
remove its' comment.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/block/blk-tag.c b/block/blk-tag.c
index c0d419e..3c518e3 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -158,7 +158,6 @@ fail:
 /**
  * blk_init_tags - initialize the tag info for an external tag map
  * @depth:	the maximum queue depth supported
- * @tags: the tag to use
  **/
 struct blk_queue_tag *blk_init_tags(int depth)
 {

