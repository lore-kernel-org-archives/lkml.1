Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbXBFDzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbXBFDzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXBFDxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:53:55 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40419 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752698AbXBFDxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:53:46 -0500
Date: Mon, 5 Feb 2007 19:53:44 -0800
Message-Id: <200702060353.l163riZ9000783@zach-dev.vmware.com>
Subject: [PATCH 11/11] Paravirt debug defaults off
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:53:44.0860 (UTC) FILETIME=[6606CDC0:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Deliberate register clobber around performance critical inline code is great for
testing, bad to leave on by default.  Many people ship with DEBUG_KERNEL turned
on, so stop making DEBUG_PARAVIRT default on.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 3a8033f42ecf arch/i386/Kconfig.debug
--- a/arch/i386/Kconfig.debug	Fri Feb 02 17:33:35 2007 -0800
+++ b/arch/i386/Kconfig.debug	Fri Feb 02 17:48:45 2007 -0800
@@ -89,7 +89,7 @@ config DOUBLEFAULT
 
 config DEBUG_PARAVIRT
 	bool "Enable some paravirtualization debugging"
-	default y
+	default n
 	depends on PARAVIRT && DEBUG_KERNEL
 	help
 	  Currently deliberately clobbers regs which are allowed to be
