Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZJRQTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZJRQTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZJRQTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbZJRQTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:19:05 -0400
Date: Sun, 18 Oct 2009 18:18:37 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHES 1/5] Remove smp_lock.h in the BKL removal effort
In-Reply-To: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910181817100.3462@localhost.localdomain>
References: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b73fc14893aa3aa106143cdf9281061bdc80918b Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 16:59:09 +0200
Subject: [PATCH] ia64: Remove include of smp_lock.c in files that no-longer have the BKL

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/ia64/ia32/sys_ia32.c           |    1 -
 arch/ia64/sn/kernel/sn2/sn_hwperf.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index c0ed49c..cbc2831 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -25,7 +25,6 @@
 #include <linux/times.h>
 #include <linux/utsname.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/mm.h>
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index 4ec7b21..179bb29 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -30,7 +30,6 @@
 #include <linux/miscdevice.h>
 #include <linux/utsname.h>
 #include <linux/cpumask.h>
-#include <linux/smp_lock.h>
 #include <linux/nodemask.h>
 #include <linux/smp.h>
 #include <linux/mutex.h>
-- 
1.6.0.6


