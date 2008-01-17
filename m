Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYAQVmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYAQVmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbYAQVlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:20 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44744 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453AbYAQVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:18 -0500
Date: Thu, 17 Jan 2008 16:40:50 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/20] UML - defconfig tweaks
Message-ID: <20080117214050.GA6787@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tweak the UML defconfig -
      we probably don't need 256 old-style ptys - this slows down udev
noticably
      enable hostfs
      disable slab debugging - another noticable performance hit

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/defconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.22/arch/um/defconfig
===================================================================
--- linux-2.6.22.orig/arch/um/defconfig	2008-01-17 14:39:06.000000000 -0500
+++ linux-2.6.22/arch/um/defconfig	2008-01-17 14:40:07.000000000 -0500
@@ -75,7 +75,7 @@ CONFIG_LD_SCRIPT_DYN=y
 CONFIG_NET=y
 CONFIG_BINFMT_ELF=y
 CONFIG_BINFMT_MISC=m
-# CONFIG_HOSTFS is not set
+CONFIG_HOSTFS=y
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
 CONFIG_MAGIC_SYSRQ=y
@@ -185,7 +185,7 @@ CONFIG_CON_CHAN="xterm"
 CONFIG_SSL_CHAN="pts"
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
+CONFIG_LEGACY_PTY_COUNT=32
 # CONFIG_WATCHDOG is not set
 CONFIG_UML_SOUND=m
 CONFIG_SOUND=m
@@ -505,7 +505,7 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
-CONFIG_DEBUG_SLAB=y
+# CONFIG_DEBUG_SLAB is not set
 # CONFIG_DEBUG_SLAB_LEAK is not set
 # CONFIG_DEBUG_MUTEXES is not set
 # CONFIG_DEBUG_SPINLOCK is not set
