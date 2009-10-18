Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZJRQVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZJRQVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZJRQVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:21:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbZJRQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:21:07 -0400
Date: Sun, 18 Oct 2009 18:19:15 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHES 2/5] Remove smp_lock.h in the BKL removal effort
In-Reply-To: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910181818540.3462@localhost.localdomain>
References: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b9aff26e4a29a47264392ea261a2c620b5077987 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 17:08:27 +0200
Subject: [PATCH] MIPS: Remove the include of smp_lock.h in files that no longer use the BKL

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/mips/basler/excite/excite_iodev.c |    1 -
 arch/mips/kernel/linux32.c             |    1 -
 arch/mips/kernel/rtlx.c                |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mips/basler/excite/excite_iodev.c b/arch/mips/basler/excite/excite_iodev.c
index 938b1d0..3676660 100644
--- a/arch/mips/basler/excite/excite_iodev.c
+++ b/arch/mips/basler/excite/excite_iodev.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
 
 #include "excite_iodev.h"
 
diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 3744608..40d75c2 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <linux/highuid.h>
 #include <linux/resource.h>
 #include <linux/highmem.h>
diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index 364f066..dcaed1b 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -28,7 +28,6 @@
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/moduleloader.h>
 #include <linux/interrupt.h>
-- 
1.6.0.6


