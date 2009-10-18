Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZJRQVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZJRQVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZJRQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:21:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbZJRQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:21:07 -0400
Date: Sun, 18 Oct 2009 18:19:53 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHES 3/5] Remove smp_lock.h in the BKL removal effort
In-Reply-To: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910181819300.3462@localhost.localdomain>
References: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 79929f091e7392004dac208c57e73792111bae69 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 17:50:50 +0200
Subject: [PATCH] powerpc: Remove the smp_lock.h include from files that don't use the BKL

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/powerpc/kernel/sys_ppc32.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 934c0f9..ec02777 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -23,7 +23,6 @@
 #include <linux/resource.h>
 #include <linux/times.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
-- 
1.6.0.6


