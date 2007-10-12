Return-Path: <linux-kernel-owner+w=401wt.eu-S932755AbXJLWjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbXJLWjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbXJLWUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:53314 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464AbXJLWUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/75] sysfs: Fix typos in fs/sysfs/file.c
Date: Fri, 12 Oct 2007 15:16:39 -0700
Message-Id: <1192227603335-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227598106-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 33bb340..16f39c3 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -335,7 +335,7 @@ static int sysfs_release(struct inode * inode, struct file * filp)
  * again will not get new data, or reset the state of 'poll'.
  * Reminder: this only works for attributes which actively support
  * it, and it is not possible to test an attribute from userspace
- * to see if it supports poll (Nether 'poll' or 'select' return
+ * to see if it supports poll (Neither 'poll' nor 'select' return
  * an appropriate error code).  When in doubt, set a suitable timeout value.
  */
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
-- 
1.5.3.4

