Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZG1WGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZG1WGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZG1WGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:06:18 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60718 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZG1WGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=RYBdOTKF4CFNXanKM0OmlGiD2hVKrzWTqw8qBmdiL1HOnEsRi9lgYakwdGXicXm8N6
         5hDBajLANqD8wm9J5kCDoPNw+NJDi4HB1d1JP7BnHjkVtw0I1tYPy4DpIp3Le0/jHVoo
         x8HJ7iHO37BSZhfqhJYqS2mcWlD5rfnFSdOCg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] mce: add missing __cpuinit tags
Date: Tue, 28 Jul 2009 23:56:00 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090728-04869-gdae50fe-dirty; KDE/4.2.4; i686; ; )
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282356.00589.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] mce: add missing __cpuinit tags

mce_cap_init() and mce_cpu_quirks() can be tagged with __cpuinit.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1162,7 +1162,7 @@ EXPORT_SYMBOL_GPL(mce_notify_irq);
 /*
  * Initialize Machine Checks for a CPU.
  */
-static int mce_cap_init(void)
+static int __cpuinit mce_cap_init(void)
 {
 	unsigned b;
 	u64 cap;
@@ -1226,7 +1226,7 @@ static void mce_init(void)
 }
 
 /* Add per CPU specific workarounds here */
-static void mce_cpu_quirks(struct cpuinfo_x86 *c)
+static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
