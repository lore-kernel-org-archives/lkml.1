Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYCNCmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYCNCmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYCNCl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:41:56 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41622 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYCNCl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:41:56 -0400
Date: Thu, 13 Mar 2008 22:41:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Greg KH <greg@kroah.com>
Subject: [PATCH] SYSFS:  Explicitly include required header file slab.h.
Message-ID: <alpine.LFD.1.00.0803132238310.30403@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After an experimental deletion of the unnecessary inclusion of
<linux/slab.h> from the header file <linux/percpu.h>, the following
files under fs/sysfs were exposed as needing to explicitly include
<linux/slab.h>.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

 fs/sysfs/dir.c  |    1 +
 fs/sysfs/file.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4948d9b..a1c3a1f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -20,6 +20,7 @@
 #include <linux/idr.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include "sysfs.h"

 DEFINE_MUTEX(sysfs_mutex);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a271c87..253f8f5 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -16,6 +16,8 @@
 #include <linux/poll.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
+
 #include <asm/uaccess.h>

 #include "sysfs.h"

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
