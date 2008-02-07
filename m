Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYBGNNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYBGNNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYBGNNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:13:05 -0500
Received: from www.tglx.de ([62.245.132.106]:58916 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYBGNND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:13:03 -0500
Date: Thu, 7 Feb 2008 14:12:36 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM
 architecture
Message-ID: <20080207141236.00940d09@dilbert.local>
In-Reply-To: <20080207130222.GA8587@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local>
	<20080207130222.GA8587@flint.arm.linux.org.uk>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 7 Feb 2008 13:02:23 +0000
schrieb Russell King - ARM Linux <linux@arm.linux.org.uk>:

> 
> Please place it in the same relative position in arch/arm/Kconfig as
> it is found in drivers/Kconfig.

Argh, sorry. Here's the correct version:
============
From: Hans J Koch <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Cc: Greg KH <greg@kroah.com>
Subject: arch/arm/Kconfig: Make UIO available on ARM architecture

Source drivers/uio/Kconfig to make UIO available in menuconfig if ARCH=arm.

Signed-off-by: Hans J Koch <hjk@linutronix.de>
---
 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig	2008-02-07 13:57:58.000000000 +0100
+++ linux-2.6/arch/arm/Kconfig	2008-02-07 14:08:46.000000000 +0100
@@ -1159,6 +1159,8 @@
 
 source "drivers/dca/Kconfig"
 
+source "drivers/uio/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"

