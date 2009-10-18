Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZJRQUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZJRQUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZJRQUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZJRQUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:20:48 -0400
Date: Sun, 18 Oct 2009 18:20:26 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHES 4/5] Remove smp_lock.h in the BKL removal effort
In-Reply-To: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910181820070.3462@localhost.localdomain>
References: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c8bebe73d370b7988989bdc92a49d190d3157b6b Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 17:52:04 +0200
Subject: [PATCH] s390: Remove the smp_lock.h include from files that don't use the BKL

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/s390/kernel/compat_linux.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index ef9c2c1..ef334f5 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -25,7 +25,6 @@
 #include <linux/resource.h>
 #include <linux/times.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
-- 
1.6.0.6


