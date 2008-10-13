Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYJMEH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYJMEH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 00:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYJMEHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 00:07:20 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:50471 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYJMEHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 00:07:19 -0400
Date: Mon, 13 Oct 2008 01:07:03 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, rbrito@ime.usp.br
Subject: [PATCH] powerpc: compile kernel for linkstations optimized for size
Message-ID: <20081013040703.GA11059@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rogério Brito <rbrito@ime.usp.br>

Since Linkstations and Kuroboxes often have *very* little memory (as
they are embedded systems), it is desirable to get their kernels
compiled optimized for size.

Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

I have been using kernels optimized for size on my Kurobox (standard)
for many different releases and I have experienced no problem with this
option enabled. Thus, this patch.

--- linux/arch/powerpc/configs/linkstation_defconfig.old	2008-10-13 00:33:00.000000000 -0300
+++ linux/arch/powerpc/configs/linkstation_defconfig	2008-10-13 00:38:58.000000000 -0300
@@ -90,7 +90,7 @@ CONFIG_NAMESPACES=y
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 # CONFIG_EMBEDDED is not set
 CONFIG_SYSCTL_SYSCALL=y


-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
