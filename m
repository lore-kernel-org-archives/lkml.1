Return-Path: <linux-kernel-owner+w=401wt.eu-S1764898AbXINFWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764898AbXINFWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 01:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXINFWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 01:22:06 -0400
Received: from ozlabs.org ([203.10.76.45]:36252 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbXINFWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 01:22:05 -0400
Subject: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Anthony Liguori <aliguori@us.ibm.com>
In-Reply-To: <1189747124.7262.36.camel@localhost.localdomain>
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <1189747124.7262.36.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 15:21:20 +1000
Message-Id: <1189747280.7262.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's pretty widely used, and the distributions will turn it on.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> 

diff -r b546335d7e75 arch/i386/Kconfig
--- a/arch/i386/Kconfig	Fri Sep 14 13:24:49 2007 +1000
+++ b/arch/i386/Kconfig	Fri Sep 14 13:27:13 2007 +1000
@@ -215,8 +215,8 @@ endchoice
 endchoice
 
 menuconfig PARAVIRT
-	bool "Paravirtualized guest support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Paravirtualized guest support"
+	default y
 	depends on !(X86_VISWS || X86_VOYAGER)
 	help
 	  Paravirtualization is a way of running multiple instances of
@@ -224,7 +224,7 @@ menuconfig PARAVIRT
 	  changes the kernel so it can modify itself when it is run
 	  under a hypervisor, improving performance significantly.
 	  However, when run without a hypervisor the kernel is
-	  theoretically slower.  If in doubt, say N.
+	  theoretically slower.  If in doubt, say Y.
 
 if PARAVIRT
 


