Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbXGKTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbXGKTj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbXGKTjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:39:19 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22160 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875AbXGKTjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:39:18 -0400
From: Michael Tokarev <mjt@tls.msk.ru>
Subject: [trivial] [2.6.22 patch] Remove one more leftover reference to devfs.
To: linux-kernel@vger.kernel.org
Message-Id: <20070711193915.842178F8A@gandalf.tls.msk.ru>
Date: Wed, 11 Jul 2007 23:39:15 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more reference to devfs in arch/i386/Kconfig, microcode driver description.

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

--- linux-2.6.22/arch/i386/Kconfig.orig	2007-07-09 03:32:17.000000000 +0400
+++ linux-2.6.22/arch/i386/Kconfig	2007-07-11 23:35:45.000000000 +0400
@@ -452,8 +452,7 @@
 	tristate "/dev/cpu/microcode - Intel IA32 CPU microcode support"
 	select FW_LOADER
 	---help---
-	  If you say Y here and also to "/dev file system support" in the
-	  'File systems' section, you will be able to update the microcode on
+	  If you say Y here, you will be able to update the microcode on
 	  Intel processors in the IA32 family, e.g. Pentium Pro, Pentium II,
 	  Pentium III, Pentium 4, Xeon etc.  You will obviously need the
 	  actual microcode binary data itself which is not shipped with the
