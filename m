Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXDJAJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXDJAJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXDJAJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:09:05 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53712 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbXDJAIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:08:44 -0400
Date: Mon, 9 Apr 2007 17:06:17 -0700
Message-Id: <200704100006.l3A06H0b020626@zach-dev.vmware.com>
Subject: [PATCH 6/10] Vmi supports compat vdso.patch
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 10 Apr 2007 00:08:43.0654 (UTC) FILETIME=[66B48260:01C77B04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the VDSO can be relocated, we can support it in VMI configurations.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 158d9ffb46fe arch/i386/Kconfig
--- a/arch/i386/Kconfig	Thu Mar 29 04:17:05 2007 -0700
+++ b/arch/i386/Kconfig	Thu Mar 29 04:18:05 2007 -0700
@@ -220,7 +220,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT && !COMPAT_VDSO
+	depends on PARAVIRT
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
