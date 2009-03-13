Return-Path: <linux-kernel-owner+w=401wt.eu-S1760539AbZCMRHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbZCMRHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759939AbZCMRBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:30 -0400
Received: from gw.goop.org ([64.81.55.164]:57445 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759858AbZCMRB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:29 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 24/27] xen mtrr: Kill some unneccessary includes
Date: Fri, 13 Mar 2009 10:00:09 -0700
Message-Id: <1236963612-14287-25-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/xen.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index 184066d..50a45db 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -1,12 +1,6 @@
 #include <linux/init.h>
-#include <linux/proc_fs.h>
-#include <linux/ctype.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
-#include <asm/uaccess.h>
-#include <linux/mutex.h>
-
-#include <asm/mtrr.h>
+#include <linux/mm.h>
+
 #include "mtrr.h"
 
 #include <xen/interface/platform.h>
-- 
1.6.0.6

