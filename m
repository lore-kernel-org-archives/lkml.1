Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYHWF4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYHWF4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 01:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYHWF4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 01:56:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:59891 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbYHWF4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 01:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=uwVHxTz2CEX8UPa6XkK0uVlGqYp2+/ALfoBuhoS0KPKVYNfJLD0Jmh8upKa5RnoY8m
         CjY0mBtLBGAQYliO2m5Mds9Uh/E/cCD45qA5LHBoC+HXBfjP3lJ/xmq5Mdu6sazdK8VQ
         Ws3l9fi8YkwmpKmCvxLtpVjTWBEkSm/F4A674=
Date: Sat, 23 Aug 2008 13:56:07 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: pq@iki.fi, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: x86, mmiotrace: remove unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080823130846.1268.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  arch/x86/mm/mmio-mod.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 635b50e..cab41df 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -25,7 +25,6 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/kallsyms.h>
 #include <asm/pgtable.h>
 #include <linux/mmiotrace.h>

