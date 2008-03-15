Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbYCOJCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbYCOJCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 05:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYCOJCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 05:02:30 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40109 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbYCOJC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 05:02:29 -0400
Date: Sat, 15 Mar 2008 05:02:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove superfluous include of string.h from percpu.h.
Message-ID: <alpine.LFD.1.00.0803150450020.11459@localhost.localdomain>
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


There's nothing in percpu.h that requires an explicit inclusion of
string.h.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  after how hideously i embarrassed myself with that earlier exchange,
i am by god going to get a patch out of this.  :-)

  compile-tested on x86 after "make allyesconfig", so that deletion
did not appear to cause any breakage anywhere in the tree.

  p.s.  for the [PATCH] subject line, what kernel subsystem would be
used for things like the header files?

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 1ac9697..d746a2a 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -4,7 +4,6 @@
 #include <linux/preempt.h>
 #include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>
-#include <linux/string.h> /* For memset() */
 #include <linux/cpumask.h>

 #include <asm/percpu.h>



========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
