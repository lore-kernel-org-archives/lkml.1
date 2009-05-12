Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZELXeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZELXeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbZELX1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:27:49 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36289
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758114AbZELX1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:27:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 6/6] xen mtrr: Kill some unnecessary includes
Date: Tue, 12 May 2009 16:27:44 -0700
Message-Id: <1242170864-13560-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170864-13560-1-git-send-email-jeremy@goop.org>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

[ Impact: cleanup ]

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/mtrr/xen.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index 5e0aa2b..4286569 100644
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

