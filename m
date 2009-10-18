Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZJRQVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZJRQVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZJRQVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:21:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbZJRQVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:21:35 -0400
Date: Sun, 18 Oct 2009 18:21:12 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHES 5/5] Remove smp_lock.h in the BKL removal effort
In-Reply-To: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910181820460.3462@localhost.localdomain>
References: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3f588af35ab828530031a19224e11d42254b72d0 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 18:01:53 +0200
Subject: [PATCH] ia32: Remove the smp_lock.h include in files that no longer use BKL

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/ia32/sys_ia32.c |    1 -
 arch/x86/kernel/cpuid.c  |    1 -
 arch/x86/kernel/msr.c    |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 32a88e4..aa9778c 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -28,7 +28,6 @@
 #include <linux/syscalls.h>
 #include <linux/times.h>
 #include <linux/utsname.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/poll.h>
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 13c8fbf..ccb0332 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -33,7 +33,6 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/device.h>
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 64a2bab..9d3f56e 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -30,7 +30,6 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/device.h>
-- 
1.6.0.6


