Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYJMEvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYJMEvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 00:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYJMEv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 00:51:27 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:50655 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYJMEv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 00:51:27 -0400
Date: Mon, 13 Oct 2008 01:51:17 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, rbrito@ime.usp.br
Subject: [PATCH] powerpc: enable heap randomization for linkstations
Message-ID: <20081013045116.GA11637@ime.usp.br>
References: <20081013040703.GA11059@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081013040703.GA11059@ime.usp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current defconfig for Linkstation/Kuroboxes has the "Disable Heap
Randomization" option enabled.

Since some of these machines are facing the internet, it helps to have
heap randomization enabled. This patch enables it.


Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

--- linux/arch/powerpc/configs/linkstation_defconfig.old	2008-10-13 00:33:00.000000000 -0300
+++ linux/arch/powerpc/configs/linkstation_defconfig	2008-10-13 01:11:28.000000000 -0300
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.27-rc4
-# Thu Aug 21 00:52:05 2008
+# Linux kernel version: 2.6.27
+# Mon Oct 13 01:11:21 2008
 #
 # CONFIG_PPC64 is not set
 
@@ -101,7 +101,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-CONFIG_COMPAT_BRK=y
+# CONFIG_COMPAT_BRK is not set
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
@@ -1211,7 +1211,6 @@ CONFIG_USB_STORAGE=m
 # CONFIG_USB_STORAGE_ALAUDA is not set
 # CONFIG_USB_STORAGE_ONETOUCH is not set
 # CONFIG_USB_STORAGE_KARMA is not set
-# CONFIG_USB_STORAGE_SIERRA is not set
 # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
 # CONFIG_USB_LIBUSUAL is not set
 

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
