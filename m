Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYBGMjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYBGMjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbYBGMjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:39:43 -0500
Received: from www.tglx.de ([62.245.132.106]:47403 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbYBGMjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:39:42 -0500
Date: Thu, 7 Feb 2008 13:38:05 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, Greg KH <greg@kroah.com>
Subject: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080207133805.13f092ff@dilbert.local>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J Koch <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Cc: Greg KH <greg@kroah.com>
Subject: arch/arm/Kconfig: Make UIO available on ARM architecture

Source drivers/uio/Kconfig to make UIO available in menuconfig if ARCH=arm.
I already posted this a few months ago, but it got lost somehow.

Signed-off-by: Hans J Koch <hjk@linutronix.de>
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig	2008-02-07 13:01:45.000000000 +0100
+++ linux-2.6/arch/arm/Kconfig	2008-02-07 13:18:22.000000000 +0100
@@ -1066,6 +1066,8 @@
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+source "drivers/uio/Kconfig"
+
 endmenu
 
 source "net/Kconfig"
