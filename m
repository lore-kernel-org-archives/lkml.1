Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXCGOa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXCGOa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030474AbXCGOa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:30:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030192AbXCGOa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:30:57 -0500
Subject: [GFS2] build fix [11/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:33:32 +0000
Message-Id: <1173278012.11001.774.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 95d97b7dd7d7a7a13d11a38b3ecb64849d2e5086 Mon Sep 17 00:00:00 2001
From: akpm@linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 5 Mar 2007 23:10:39 -0800
Subject: [PATCH] [GFS2] build fix

fs/gfs2/glock.c:2198: error: 'THIS_MODULE' undeclared here (not in a function)

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8597fde..12accb0 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/lm_interface.h>
 #include <linux/wait.h>
+#include <linux/module.h>
 #include <linux/rwsem.h>
 #include <asm/uaccess.h>
 
-- 
1.4.4.2



