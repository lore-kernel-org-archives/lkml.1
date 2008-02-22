Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYBVR2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYBVR2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYBVR2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:28:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYBVR2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:28:05 -0500
Message-ID: <47BF0603.9040201@redhat.com>
Date: Fri, 22 Feb 2008 11:27:31 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] include falloc.h in header-y
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include falloc.h in header-y; it defines a flag
for the fallocate sysctl.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

--- linux.orig/include/linux/Kbuild
+++ linux/include/linux/Kbuild
@@ -61,6 +61,7 @@ header-y += efs_fs_sb.h
 header-y += elf-fdpic.h
 header-y += elf-em.h
 header-y += fadvise.h
+header-y += falloc.h
 header-y += fd.h
 header-y += fdreg.h
 header-y += fib_rules.h

