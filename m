Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbYDBSix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbYDBSix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbYDBSfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:42 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38410 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757121AbYDBSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:38 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 24] xen: add missing VIRQ_ARCH_[0-7] definitions which
	ia64/xen needs
X-Mercurial-Node: 1d752e8085f343c8d871a4021642ad7e578dfdef
Message-Id: <1d752e8085f343c8d871.1207158831@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

Add xen VIRQ numbers defined for arch specific use.
ia64/xen domU uses VIRQ_ARCH_0 for virtual itc timer.
Although all those constants aren't used yet by ia64
at this moment, add all arch specific VIRQ numbers.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/xen/interface/xen.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -78,8 +78,18 @@
 #define VIRQ_CONSOLE    2  /* (DOM0) Bytes received on emergency console. */
 #define VIRQ_DOM_EXC    3  /* (DOM0) Exceptional event for some domain.   */
 #define VIRQ_DEBUGGER   6  /* (DOM0) A domain has paused for debugging.   */
-#define NR_VIRQS        8
 
+/* Architecture-specific VIRQ definitions. */
+#define VIRQ_ARCH_0    16
+#define VIRQ_ARCH_1    17
+#define VIRQ_ARCH_2    18
+#define VIRQ_ARCH_3    19
+#define VIRQ_ARCH_4    20
+#define VIRQ_ARCH_5    21
+#define VIRQ_ARCH_6    22
+#define VIRQ_ARCH_7    23
+
+#define NR_VIRQS       24
 /*
  * MMU-UPDATE REQUESTS
  *


