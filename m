Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYBPDW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYBPDW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYBPDWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:22:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:24358 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYBPDWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:22:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iBzUtYAHYuASCmJ/k0xs2ZOD4ERKdbzglfe5yINp6/mg1Na6qywlBp5U9otEjxzQuha6hfIbdeYwy18BnUE9yCDq4yYppC+cyHvc8oHS1KvVEMYKJpAVZVQDOb//iUjSLxRnjzLg5ujhLNb/iXVELbOne9mTfOkcqWRrBE2CjqA=
Subject: [PATCH 1/4] jffs2: include function prototype for jffs2_ioctl
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 19:22:13 -0800
Message-Id: <1203132133.7442.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/jffs2/ioctl.c:14:5: warning: symbol 'jffs2_ioctl' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/jffs2/ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/jffs2/ioctl.c b/fs/jffs2/ioctl.c
index f4d525b..e217721 100644
--- a/fs/jffs2/ioctl.c
+++ b/fs/jffs2/ioctl.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/fs.h>
+#include "nodelist.h"
 
 int jffs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		unsigned long arg)
-- 
1.5.4.1.1278.gc75be


