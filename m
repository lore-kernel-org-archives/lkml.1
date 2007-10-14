Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbXJNFxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbXJNFxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXJNFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:53:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36945 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbXJNFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:53:47 -0400
Date: Sun, 14 Oct 2007 06:53:45 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] more uevent fallout (drivers/base/memory.c)
Message-ID: <20071014055345.GU8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index cb99dae..7a1390c 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -34,7 +34,7 @@ static const char *memory_uevent_name(struct kset *kset, struct kobject *kobj)
 	return MEMORY_CLASS_NAME;
 }
 
-static int memory_uevent(struct kset *kset, struct kobj_uevent_env *env)
+static int memory_uevent(struct kset *kset, struct kobject *obj, struct kobj_uevent_env *env)
 {
 	int retval = 0;
 
