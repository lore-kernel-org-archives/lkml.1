Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYCNCza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYCNCza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYCNCzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:55:23 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:42246 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYCNCzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:55:22 -0400
Date: Thu, 13 Mar 2008 22:55:19 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] SECURITY:  Explicitly include required slab.h header file.
Message-ID: <alpine.LFD.1.00.0803132252220.4683@localhost.localdomain>
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


Since these two source files invoke kmalloc(), they should explicitly
include <linux/slab.h>.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  i wasn't sure who the corrrect recipient of this would be.

 security/keys/request_key.c      |    1 +
 security/keys/request_key_auth.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 5ecc505..cd7f880 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -16,6 +16,7 @@
 #include <linux/kmod.h>
 #include <linux/err.h>
 #include <linux/keyctl.h>
+#include <linux/slab.h>
 #include "internal.h"

 /*
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index e42b525..31ff359 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include "internal.h"

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
