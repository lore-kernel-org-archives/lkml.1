Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZBITDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZBITDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZBITDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:03:05 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46028 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZBITDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:03:03 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 1/1] integrity: shmem zero fix
Date: Mon,  9 Feb 2009 14:00:29 -0500
Message-Id: <1234206029-21460-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved ima.h include before CONFIG_SHMEM test

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/mm/shmem.c b/mm/shmem.c
index 7519988..8135fac 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/swap.h>
+#include <linux/ima.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -59,7 +60,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
 #include <linux/magic.h>
-#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
-- 
1.5.6.6

