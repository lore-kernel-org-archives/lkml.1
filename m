Return-Path: <linux-kernel-owner+w=401wt.eu-S1423525AbXEAKP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423525AbXEAKP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423384AbXEAKP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:15:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423462AbXEAKPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:15:17 -0400
Subject: [GFS2] Set drop_count to 0 (off) by default [15/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:10:44 +0100
Message-Id: <1178014244.5462.157.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From f01963f2648cfd708ee8d521b3737cfa55ea8795 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 2 Apr 2007 10:03:24 +0100
Subject: [PATCH] [GFS2] Set drop_count to 0 (off) by default

This sets the drop_count to 0 by default which is a better default
for most people.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index 6888bd4..d074c6e 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -36,7 +36,7 @@
 
 #define GDLM_STRNAME_BYTES	24
 #define GDLM_LVB_SIZE		32
-#define GDLM_DROP_COUNT		200000
+#define GDLM_DROP_COUNT		0
 #define GDLM_DROP_PERIOD	60
 #define GDLM_NAME_LEN		128
 
-- 
1.5.1.2



