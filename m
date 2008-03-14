Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYCNCLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYCNCLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYCNCL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:11:27 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40391 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYCNCL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:11:26 -0400
Date: Thu, 13 Mar 2008 22:11:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: rathamahata@php4.ru
Subject: [PATCH] BEFS:  Explicitly include required header file slab.h.
Message-ID: <alpine.LFD.1.00.0803132209400.17859@localhost.localdomain>
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


Since fs/befs/debug.c invokes kmalloc(), it should explicitly include
<linux/slab.h>.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/fs/befs/debug.c b/fs/befs/debug.c
index b8e304a..622e737 100644
--- a/fs/befs/debug.c
+++ b/fs/befs/debug.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/slab.h>

 #endif				/* __KERNEL__ */

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
