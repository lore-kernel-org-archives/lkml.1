Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbXCECBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbXCECBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXCEBrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:47:51 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49907 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbXCEBre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:34 -0500
Date: Mon, 5 Mar 2007 02:47:35 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] remove arch/i386/kernel/tsc.c:custom_sched_clock
Message-ID: <20070305014735.GP3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
> +vmi-sched-clock-paravirt-op-fix.patch
>...
>  2.6.21 queue
>...

This patch removes the no longer used custom_sched_clock.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/arch/i386/kernel/tsc.c.old	2007-03-04 19:02:54.000000000 +0100
+++ linux-2.6.21-rc2-mm1/arch/i386/kernel/tsc.c	2007-03-04 19:03:00.000000000 +0100
@@ -24,7 +24,6 @@
  * an extra value to store the TSC freq
  */
 unsigned int tsc_khz;
-unsigned long long (*custom_sched_clock)(void);
 
 int tsc_disable;
 

