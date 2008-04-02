Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbYDBSjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbYDBSjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbYDBSfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:42 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38408 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757189AbYDBSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:38 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 24] xen: move features.c from arch/x86/xen/features.c to
	drivers/xen
X-Mercurial-Node: 08fcd88387c0838b1635654923420119870e3192
Message-Id: <08fcd88387c0838b1635.1207158834@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

ia64/xen also uses it too. Move it into common place so that
ia64/xen can share the code.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile  |    2 +-
 drivers/xen/Makefile   |    2 +-
 drivers/xen/features.c |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o \
+obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
 			events.o time.o manage.o xen-asm.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,2 +1,2 @@
-obj-y	+= grant-table.o
+obj-y	+= grant-table.o features.o
 obj-y	+= xenbus/
diff --git a/arch/x86/xen/features.c b/drivers/xen/features.c
rename from arch/x86/xen/features.c
rename to drivers/xen/features.c


