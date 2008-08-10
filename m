Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYHJNJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYHJNJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 09:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYHJNJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 09:09:27 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:34696 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYHJNJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 09:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=MBC56qZaYhdNbuHK7wqCkC8+AwkZJjhdxDgpYaSzh/1edGVmudMcGJVfApG1BiBgWL
         A9XWI8I2++3RkzRGWDdu4aUbOiewBvQfPUJMDLra9NdEAVuBqkE+X7F18LuSmHJLfGdF
         GtyWLhNwNKHSZDKgofBbc9MtTiGtLA8xoXefc=
Date: Sun, 10 Aug 2008 21:09:22 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: tglx@linutronix.de
Subject: arch/x86/kernel/cpuid.c: removed duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080810210512.2EFD.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated include file <linux/smp_lock.h> in 
arch/x86/kernel/cpuid.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 14b11b3..3fa4e92 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -36,7 +36,6 @@
 #include <linux/smp_lock.h>
 #include <linux/major.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>

