Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbXJDJVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbXJDJVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbXJDJRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbXJDJRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:36 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Denis Cheng <crquan@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/51] [GFS2] use the declaration of gfs2_dops in the header file instead
Date: Thu,  4 Oct 2007 09:49:05 +0100
Message-Id: <1191487812928-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878102813-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

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
1.5.1.2

