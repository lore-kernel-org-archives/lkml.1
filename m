Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZIVHEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZIVHEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZIVHEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:04:38 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:50153
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbZIVHEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:04:37 -0400
X-Greylist: delayed 1122 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2009 03:04:37 EDT
Subject: [PATCH 1/2] score: add head files define in vmlinux.lds.S
From: Chen Liqin <liqin.chen@sunplusct.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, liqin.gnu@gmail.com
Content-Type: text/plain
Date: Tue, 22 Sep 2009 14:32:02 +0800
Message-Id: <1253601122.27225.2.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/score/kernel/vmlinux.lds.S b/arch/score/kernel/vmlinux.lds.S
index aab4703..eebcbaa 100644
--- a/arch/score/kernel/vmlinux.lds.S
+++ b/arch/score/kernel/vmlinux.lds.S
@@ -24,6 +24,8 @@
  */
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/thread_info.h>
+#include <asm/page.h>
 
 OUTPUT_ARCH(score)
 ENTRY(_stext)
-- 
1.6.2



