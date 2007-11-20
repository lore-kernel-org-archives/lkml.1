Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbXKTCLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbXKTCLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbXKTByX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:54:23 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2224 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbXKTByB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:54:01 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@parisplace.org>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 57/59] security/selinux: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:44 -0800
Message-Id: <1195523627-15389-15-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523627-15389-14-git-send-email-joe@perches.com>
References: 1234567
 <1195523627-15389-1-git-send-email-joe@perches.com>
 <1195523627-15389-2-git-send-email-joe@perches.com>
 <1195523627-15389-3-git-send-email-joe@perches.com>
 <1195523627-15389-4-git-send-email-joe@perches.com>
 <1195523627-15389-5-git-send-email-joe@perches.com>
 <1195523627-15389-6-git-send-email-joe@perches.com>
 <1195523627-15389-7-git-send-email-joe@perches.com>
 <1195523627-15389-8-git-send-email-joe@perches.com>
 <1195523627-15389-9-git-send-email-joe@perches.com>
 <1195523627-15389-10-git-send-email-joe@perches.com>
 <1195523627-15389-11-git-send-email-joe@perches.com>
 <1195523627-15389-12-git-send-email-joe@perches.com>
 <1195523627-15389-13-git-send-email-joe@perches.com>
 <1195523627-15389-14-git-send-email-joe@perches.com>
Message-Id: <33ce09d8744eb1941b300c2a9986ae29d0660e02.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 security/selinux/ss/avtab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/ss/avtab.c b/security/selinux/ss/avtab.c
index 9e70a16..cd10e27 100644
--- a/security/selinux/ss/avtab.c
+++ b/security/selinux/ss/avtab.c
@@ -280,7 +280,7 @@ int avtab_alloc(struct avtab *h, u32 nrules)
 	h->nel = 0;
 	h->nslot = nslot;
 	h->mask = mask;
-	printk(KERN_DEBUG "SELinux:%d avtab hash slots allocated."
+	printk(KERN_DEBUG "SELinux:%d avtab hash slots allocated. "
 	       "Num of rules:%d\n", h->nslot, nrules);
 	return 0;
 }
-- 
1.5.3.5.652.gf192c

