Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYIXCkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYIXCkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 22:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIXCkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 22:40:07 -0400
Received: from relais.videotron.ca ([24.201.245.36]:20942 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYIXCkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 22:40:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <48D9A882.4080804@gmail.com>
Date: Tue, 23 Sep 2008 22:40:02 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Fix build error introduced by commit
 4faac97d44ac27bdbb010a9c3597401a8f89341f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

process_32.c needs to include idle.h to get the prototype for 
c1e_remove_cpu()

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
---
 arch/x86/kernel/process_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4b3cfdf..31f40b2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,6 +55,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
+#include <asm/idle.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
-- 
1.6.0.1

