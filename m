Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbXCAMkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbXCAMkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXCAMkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:40:23 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:34308 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbXCAMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:40:22 -0500
Date: Thu, 1 Mar 2007 12:40:21 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix sysfs build breakage if !CONFIG_SYSFS
Message-ID: <20070301124020.GA2023@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

B0rkage introduced by dfa87c824a9a5430008acd1ed2e8111ed164fcbe.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 21805b5..523405e 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -211,9 +211,8 @@ static inline int sysfs_add_file_to_group(struct kobject *kobj,
 }
 
 static inline void sysfs_remove_file_from_group(struct kobject *kobj,
-		const struct attribute *attr, const char *group);
+		const struct attribute *attr, const char *group)
 {
-	;
 }
 
 static inline void sysfs_notify(struct kobject * k, char *dir, char *attr)
