Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbZJaJmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbZJaJmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932857AbZJaJmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:42:20 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbZJaJmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=JPt+UHqdyltSPTeHy6WilyEiVQ1Bs8dvhFvWT+bp9qvsNX7lwXeJ4lSveZnJ/e84EJ
         S3w+85OpJ7jd/7PIzOwxcIwps2tSdvlCHXlkRJWfLbTPK1Cce8DG1P7hpL5owXHeabok
         2xOezRSAqpvYJZ05wfNcVKuCmAzYBoFz4BWBY=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:42:00 -0200
Message-ID: <b8bf37780910310242q4aca4597t70e40ea48fa4f43c@mail.gmail.com>
Subject: [PATCH 15/16] trivial: fix assorted "hierarchy" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ea6eee92bee07b1946f92f5d64c1973ea44e19b1 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 07:12:58 -0200
Subject: [PATCH 15/16] trivial: fix assorted "hierarchy" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/fs/xfs/quota/xfs_dquot.h b/fs/xfs/quota/xfs_dquot.h
index 6533ead..a2c16bc 100644
--- a/fs/xfs/quota/xfs_dquot.h
+++ b/fs/xfs/quota/xfs_dquot.h
@@ -98,7 +98,7 @@ typedef struct xfs_dquot {
 #define dq_flags	q_lists.dqm_flags

 /*
- * Lock hierachy for q_qlock:
+ * Lock hierarchy for q_qlock:
  *	XFS_QLOCK_NORMAL is the implicit default,
  * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
  */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f99f599..5202299 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -209,7 +209,7 @@ struct mem_cgroup {
 	int	prev_priority;	/* for recording reclaim priority */

 	/*
-	 * While reclaiming in a hiearchy, we cache the last child we
+	 * While reclaiming in a hierarchy, we cache the last child we
 	 * reclaimed from.
 	 */
 	int last_scanned_child;
@@ -2466,7 +2466,7 @@ static int mem_cgroup_hierarchy_write(struct
cgroup *cont, struct cftype *cft,

 	cgroup_lock();
 	/*
-	 * If parent's use_hiearchy is set, we can't make any modifications
+	 * If parent's use_hierarchy is set, we can't make any modifications
 	 * in the child subtrees. If it is unset, then the change can
 	 * occur, provided the current cgroup has no children.
 	 *
-- 
1.6.5.2.101.gcd0f8
