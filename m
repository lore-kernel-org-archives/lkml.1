Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZDULRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZDULRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 07:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZDULRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 07:17:12 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:51356 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZDULRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 07:17:11 -0400
Date: Tue, 21 Apr 2009 13:17:04 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: unknown config var ETRAXFS_SIM
Message-ID: <20090421111704.GS21811@axis.com>
References: <alpine.LFD.2.00.0904191600430.15998@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904191600430.15998@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 10:01:50PM +0200, Robert P. J. Day wrote:
> ./arch/cris/arch-v32/kernel/Makefile:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
> 
>   there appears to be no definition of ETRAXFS_SIM anywhere.

Yeah, and there's no vcs_hook.c file there either.
I've queued this patch to the CRIS tree:

There hasn't been a vcs_hook.c file here for ages.
Remove the line from the Makefile.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Reported-by: "Robert P. J. Day" <rpjday@crashcourse.ca>
---
 arch/cris/arch-v32/kernel/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/Makefile b/arch/cris/arch-v32/kernel/Makefile
index 993d987..4035835 100644
--- a/arch/cris/arch-v32/kernel/Makefile
+++ b/arch/cris/arch-v32/kernel/Makefile
@@ -9,8 +9,6 @@ obj-y   := entry.o traps.o irq.o debugport.o \
 	   process.o ptrace.o setup.o signal.o traps.o time.o \
 	   cache.o cacheflush.o
 
-obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
-
 obj-$(CONFIG_SMP) += smp.o
 obj-$(CONFIG_ETRAX_KGDB) += kgdb.o kgdb_asm.o
 obj-$(CONFIG_ETRAX_FAST_TIMER) += fasttimer.o
-- 
1.6.1

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
