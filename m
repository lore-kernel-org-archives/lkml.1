Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXBEOfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXBEOfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXBEOfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:35:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXBEOfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:35:19 -0500
Subject: [GFS2] increase default lock limit [45/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:43:15 +0000
Message-Id: <1170686595.11001.361.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From b3ffa7fa110a62b6e835016c944dbd687b21731e Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Thu, 25 Jan 2007 13:50:52 -0600
Subject: [PATCH] [GFS2] increase default lock limit

Increase the number of locks at which point the dlm begins asking gfs to
reduce its lock usage.  The default value is largely arbitrary, but the
current value of 50,000 ends up limiting performance unnecessarily for too
many users.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index 33af707..a87c7bf 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -36,7 +36,7 @@
 
 #define GDLM_STRNAME_BYTES	24
 #define GDLM_LVB_SIZE		32
-#define GDLM_DROP_COUNT		50000
+#define GDLM_DROP_COUNT		200000
 #define GDLM_DROP_PERIOD	60
 #define GDLM_NAME_LEN		128
 
-- 
1.4.4.2



