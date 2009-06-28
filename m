Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbZF1Qab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbZF1Qab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZF1Q1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:21 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1079 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZF1Q1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:16 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux390@de.ibm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 06/62] arch/s390/hypfs/inode.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:11 -0700
Message-Id: <636ad4e60c446ef84da6750c1d7c94ad263d2370.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/hypfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 5a805df..ad0a1dd 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -500,7 +500,7 @@ static int __init hypfs_init(void)
 	}
 	s390_kobj = kobject_create_and_add("s390", hypervisor_kobj);
 	if (!s390_kobj) {
-		rc = -ENOMEM;;
+		rc = -ENOMEM;
 		goto fail_sysfs;
 	}
 	rc = register_filesystem(&hypfs_type);
-- 
1.6.3.1.10.g659a0.dirty

