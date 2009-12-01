Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbZLAIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbZLAIvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZLAIvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:51:16 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:40744 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZLAIvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:51:16 -0500
Date: Tue, 1 Dec 2009 14:21:20 +0530
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>
Subject: [RFC] [PATCH 2/2] Futex fault injection: Config option
Message-ID: <20091201142120.149f654a@sripathi>
In-Reply-To: <20091201141642.398e7b7d@sripathi>
References: <20091201141642.398e7b7d@sripathi>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds config option to control futex fault injection.

Thanks,
Sripathi.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

---

Index: linux-2.6.32-rc8/lib/Kconfig.debug
===================================================================
--- linux-2.6.32-rc8.orig/lib/Kconfig.debug	2009-11-30 12:21:44.000000000 +0530
+++ linux-2.6.32-rc8/lib/Kconfig.debug	2009-11-30 15:24:42.000000000 +0530
@@ -882,6 +882,14 @@
 	  Only works with drivers that use the generic timeout handling,
 	  for others it wont do anything.
 
+config FAIL_FUTEX_EFAULT
+	bool "Fault injection capability for futex subsystem"
+	depends on FAULT_INJECTION
+	help
+	  Provide fault injection capability for user-space read-write
+	  in futex subsystem. Injects EFAULT errors while read/writing
+	  values from user space
+
 config FAULT_INJECTION_DEBUG_FS
 	bool "Debugfs entries for fault-injection capabilities"
 	depends on FAULT_INJECTION && SYSFS && DEBUG_FS
