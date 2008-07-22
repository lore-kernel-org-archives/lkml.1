Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYGVWZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYGVWZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYGVWZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:25:30 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:58412 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbYGVWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:25:29 -0400
X-Greylist: delayed 1341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 18:25:29 EDT
Date: Tue, 22 Jul 2008 23:03:06 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ALi M7101 PMU also available on Sun Netra's too
Message-ID: <20080722220306.GA4832@inskipp.digriz.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: diGriz
X-URL: http://www.digriz.org.uk/
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Well my Sun Netra T1 AC200 has one of these...bit harsh not letting me use it 
and all :)

==========
alex@woodchuck:~$ lspci -nn 
00:01.0 PCI bridge [0604]: Sun Microsystems Computer Corp. Simba Advanced PCI Bridge [108e:5000] (rev 13)
00:01.1 PCI bridge [0604]: Sun Microsystems Computer Corp. Simba Advanced PCI Bridge [108e:5000] (rev 13)
01:03.0 Non-VGA unclassified device [0000]: ALi Corporation M7101 Power Management Controller [PMU] [10b9:7101]
01:05.1 Ethernet controller [0200]: Sun Microsystems Computer Corp. RIO GEM [108e:1101] (rev 01)
01:05.3 USB Controller [0c03]: Sun Microsystems Computer Corp. RIO USB [108e:1103] (rev 01)
01:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin IV/V/V+] [10b9:1533]
01:0c.0 Bridge [0680]: Sun Microsystems Computer Corp. RIO EBUS [108e:1100] (rev 01)
01:0c.1 Ethernet controller [0200]: Sun Microsystems Computer Corp. RIO GEM [108e:1101] (rev 01)
01:0c.3 USB Controller [0c03]: Sun Microsystems Computer Corp. RIO USB [108e:1103] (rev 01)
01:0d.0 IDE interface [0101]: ALi Corporation M5229 IDE [10b9:5229] (rev c3)
02:08.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic 53C896/897 [1000:000b] (rev 07)
02:08.1 SCSI storage controller [0100]: LSI Logic / Symbios Logic 53C896/897 [1000:000b] (rev 07)
==========

Cheers

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>

--- linux-2.6.26/drivers/watchdog/Kconfig.orig	2008-07-22 22:49:38.386293182 +0100
+++ linux-2.6.26/drivers/watchdog/Kconfig	2008-07-22 22:53:38.087273613 +0100
@@ -285,10 +285,11 @@
 
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
