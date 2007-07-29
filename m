Return-Path: <linux-kernel-owner+w=401wt.eu-S965326AbXG2Wa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326AbXG2Wa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964833AbXG2WaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:30:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:33315 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853AbXG2WaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=p5x3Gski76yIeVWiPosChzV4L86HCtb2lyN99i7XDmyEm32Rf+OaMEUISt6RvqpLWOPTIISj1uxDY08Nn7bzMBs9vy4HAyMdgoctuSbz/o5nwY6SlDk5pkgYhgfJahhw/PyvFwWGWhtq5BCzBBw21z2DthUE759IHCPNkTAhWTo=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Tony Luck <tony.luck@intel.com>, Jes Sorensen <jes@sgi.com>
Subject: [PATCH] ia64: Remove a few duplicate includes
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ia64@vger.kernel.org,
       linux-altix@sgi.com, Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 30 Jul 2007 00:28:42 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707300028.42496.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry about the duplicate mail, forgot a recipient first time)

Hi,


This patch removes a few duplicate includes from arch/ia64/


Please consider merging :-)



Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 arch/ia64/ia32/sys_ia32.c   |    1 -
 arch/ia64/kernel/setup.c    |    1 -
 arch/ia64/sn/kernel/setup.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index af10462..a3405b3 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -34,7 +34,6 @@
 #include <linux/uio.h>
 #include <linux/nfs_fs.h>
 #include <linux/quota.h>
-#include <linux/syscalls.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/cache.h>
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 7cecd29..cd9a37a 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -60,7 +60,6 @@
 #include <asm/smp.h>
 #include <asm/system.h>
 #include <asm/unistd.h>
-#include <asm/system.h>
 
 #if defined(CONFIG_SMP) && (IA64_CPU_SIZE > PAGE_SIZE)
 # error "struct cpuinfo_ia64 too big!"
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index 684b1c9..1f38a3a 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -25,7 +25,6 @@
 #include <linux/interrupt.h>
 #include <linux/acpi.h>
 #include <linux/compiler.h>
-#include <linux/sched.h>
 #include <linux/root_dev.h>
 #include <linux/nodemask.h>
 #include <linux/pm.h>


