Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbXJKWhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbXJKWhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXJKWhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:37:13 -0400
Received: from serv04.lahn.de ([213.239.197.57]:33731 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbXJKWhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:37:12 -0400
X-Greylist: delayed 1748 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 18:37:11 EDT
Date: Fri, 12 Oct 2007 00:07:22 +0200
From: Michael Leun <ml@newton.leun.net>
To: linux-kernel@vger.kernel.org
Subject: solved: 2.6.23 && fglrx && s2ram
Message-ID: <20071012000722.3cbf17b6@elektra.leun.net>
Organization: Not Organized
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.11; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(please, don't blame me for using the binary only driver, I will
happily switch to a open source one once it properly runs mplayer,
e.g.).

Renaming the config options for suspend/sleep broke fglrx power
management.

--- firegl_public.h.orig	2007-10-11 23:43:26.000000000 +0200
+++ firegl_public.h	2007-10-11 23:53:08.000000000 +0200
@@ -172,7 +172,7 @@
 #endif
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-#if !defined(CONFIG_SMP) || defined(CONFIG_SUSPEND_SMP) // ACPI not working on older SMP kernel (prior to 2.6.13) 
+#if !defined(CONFIG_SMP) || defined(CONFIG_PM_SLEEP_SMP) // ACPI not working on older SMP kernel (prior to 2.6.13) 
 #define FIREGL_POWER_MANAGEMENT
 #endif
 #endif
 

-- 
MfG,

Michael Leun

