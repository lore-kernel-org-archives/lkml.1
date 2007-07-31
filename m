Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbXGaKba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbXGaKba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbXGaKbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:31:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:62250 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589AbXGaKbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:31:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bjKVit1JIti6elDecxd6IiVpmD6AcoPYuyUrzS3Q6jR7/f1hfQoWNO6KxAxBoIiFJ9FsygOk01GMbPn217sf4icURYGCBFcfLFNMN33S34hHU2NNl+ewm03G0YZGG1TSNtdx8dJEAMx3sDNG5e4KsGDYzgUQz4F8j/FO6JBEZtE=
From: Denis Cheng <crquan@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, chdebra@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] fs/gfs2: use the declaration of gfs2_dops in the header file instead
Date: Tue, 31 Jul 2007 18:31:12 +0800
Message-Id: <11858778843416-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1185877873787-git-send-email-crquan@gmail.com>
References: <1185873464.8765.564.camel@quoit>
 <1185877873787-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/gfs2/ops_fstype.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index cf5aa50..9a5e840 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -28,6 +28,7 @@
 #include "lm.h"
 #include "mount.h"
 #include "ops_fstype.h"
+#include "ops_dentry.h"
 #include "ops_super.h"
 #include "recovery.h"
 #include "rgrp.h"
@@ -38,8 +39,6 @@
 #define DO 0
 #define UNDO 1
 
-extern struct dentry_operations gfs2_dops;
-
 static struct gfs2_sbd *init_sbd(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp;
-- 
1.5.2.2

