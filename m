Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbYGaSZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbYGaSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYGaSZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:25:10 -0400
Received: from main.gmane.org ([80.91.229.2]:56597 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbYGaSZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:25:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: 2.6.27-rc1-mm1
Date: Thu, 31 Jul 2008 18:20:51 +0000 (UTC)
Message-ID: <loom.20080731T181637-604@post.gmane.org>
References: <20080731000354.24b55d5b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 69.30.121.162 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070730 SUSE/2.0.0.6-25 Firefox/2.0.0.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm <at> linux-foundation.org> writes:


> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/
+ 2.6/2.6.27-rc1/2.6.27-rc1-mm1/
> 
> - Something in linux-next has broken my X server
> 
> - My Vaio is vacationing on the other side of the continent.  Ignorance
>   is bliss.
> 
> - Lots of people are vacationing at present (certain x86 people, for
>   example).  I'll still be around so please be sure to Cc me on things.
> 
>   But I am unlikely to want to be buried in x86 patches, so please just
>   give those an extra week or two's testing.

What happened with drivers/watchdog/Kconfig* ?


--- linux-2.6.27-rc1/drivers/watchdog/Kconfig	2008-07-29
+++ 25/drivers/watchdog/Kconfig	2008-07-30
@@ -285,10 +285,11 @@ config ALIM1535_WDT
 
 config ALIM7101_WDT
 	tristate "ALi M7101 PMU Computer Watchdog"
-	depends on X86 && PCI
+	depends on PCI
 	help
 	  This is the driver for the hardware watchdog on the ALi M7101 PMU
-	  as used in the x86 Cobalt servers.
+	  as used in the x86 Cobalt servers and also found in some
+	  SPARC Netra servers too.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called alim7101_wdt.
--- /dev/null	2008-06-22
+++ 25/drivers/watchdog/Kconfig.orig	2008-07-23
@@ -0,0 +1,934 @@

etc......

Broken, isn't it?


~Randy

