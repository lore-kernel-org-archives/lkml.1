Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZC2FtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZC2FtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 01:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZC2FtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 01:49:13 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:16844 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZC2FtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 01:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=F4PUDbTBc2MeZez02ksoEU8loyK3/SDJ4JmhSg19BtSmFtCLoThSzssXZoBVdyL3Wd
         BUFLUG+Mcj/YwpGkx044po8bR+zHmAlqLbEGQPqWhN/GxfCAYrLQcbBIyKyI6b8P9sqX
         iRZTbD0E+pIAwhoQBDRYufjcCzt5LEhqyH20Q=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@elte.hu, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 4/4] x86_32: apic/summit_32, remove duplicated #include
Date: Sun, 29 Mar 2009 13:49:03 +0800
Message-Id: <1238305743-1312-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated #include in arch/x86/kernel/apic/summit_32.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 arch/x86/kernel/apic/summit_32.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index aac52fa..37b6b8d 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -44,7 +44,6 @@
 #include <asm/ipi.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/smp.h>
 
-- 
1.6.1.3

