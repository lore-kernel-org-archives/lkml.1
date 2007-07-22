Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXGVFOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXGVFOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbXGVFOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:14:16 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:10725 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXGVFOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:14:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HuBVLZ7iZsXANI8Jy+iOLUUGVzl/+epvF62TRXMrSFZUAFGdW5MBNZ/tm3plVA/SuLrBCJ9+eTgnU3D3VEMMmj1dmnOh/FXjGnXtrGAzYE7eRMdoCFIx3PRY9RLocD36pTXT9DNWKx0i+kGJJ5V1TIPPFtC9nPCz4FTxLFBGMJc=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [00/37] Clean up duplicate includes (resend patch 12)
Date: Sun, 22 Jul 2007 07:13:16 +0200
User-Agent: KMail/1.9.7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <200707211701.23911.jesper.juhl@gmail.com> <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
In-Reply-To: <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220713.16164.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 04:30:41 Satyam Sharma wrote:
> On 7/21/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > [...]
> > These are the patches in this series :
> 
> Ok, I've reviewed all patches in this series except:
> 
> >  [PATCH][12/37] Clean up duplicate includes in drivers/net/
> >  [PATCH][28/37] Clean up duplicate includes in net/ipv4/
> >  [PATCH][32/37] Clean up duplicate includes in net/sunrpc/
> 

Here's a resend of patch 12.

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index fd1e156..4a18b88 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -75,7 +75,6 @@
 #include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/mii.h>
-#include <linux/interrupt.h>
 #include <net/checksum.h>
 
 #include <asm/atomic.h>
diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 9a08d65..01281ee 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -47,15 +47,10 @@
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
-
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
-
 #include <linux/platform_device.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/skbuff.h>
 
 #include <asm/dma.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 60cccf2..9afd172 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -31,7 +31,6 @@
 #include <linux/inetdevice.h>
 #include <linux/in.h>
 #include <linux/sysfs.h>
-#include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/inet.h>
 #include <linux/rtnetlink.h>
diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index a4a2a0e..27de3d8 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -39,8 +39,6 @@
 
 #include <linux/vmalloc.h>
 #include <asm/pgtable.h>
-
-#include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/gianfar.h b/drivers/net/gianfar.h
index d8e779c..43c8668 100644
--- a/drivers/net/gianfar.h
+++ b/drivers/net/gianfar.h
@@ -45,7 +45,6 @@
 #include <linux/crc32.h>
 #include <linux/workqueue.h>
 #include <linux/ethtool.h>
-#include <linux/netdevice.h>
 #include <linux/fsl_devices.h>
 #include "gianfar_mii.h"
 
diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
index 7b411c1..2470903 100644
--- a/drivers/net/gianfar_ethtool.c
+++ b/drivers/net/gianfar_ethtool.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/crc32.h>
 #include <asm/types.h>
-#include <asm/uaccess.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
diff --git a/drivers/net/irda/kingsun-sir.c b/drivers/net/irda/kingsun-sir.c
index bdd5c97..4c0d379 100644
--- a/drivers/net/irda/kingsun-sir.c
+++ b/drivers/net/irda/kingsun-sir.c
@@ -66,7 +66,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
diff --git a/drivers/net/irda/mcs7780.c b/drivers/net/irda/mcs7780.c
index 0de8672..bfc5752 100644
--- a/drivers/net/irda/mcs7780.c
+++ b/drivers/net/irda/mcs7780.c
@@ -50,7 +50,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
diff --git a/drivers/net/mipsnet.c b/drivers/net/mipsnet.c
index 9853c74..c0f5ad3 100644
--- a/drivers/net/mipsnet.c
+++ b/drivers/net/mipsnet.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/netdevice.h>
 #include <linux/platform_device.h>
 #include <asm/io.h>
 #include <asm/mips-boards/simint.h>
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index b703ccf..6ba8e07 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -39,7 +39,6 @@
 #include "netxen_nic_phan_reg.h"
 
 #include <linux/dma-mapping.h>
-#include <linux/vmalloc.h>
 #include <net/ip.h>
 
 MODULE_DESCRIPTION("NetXen Multi port (1/10) Gigabit Network Driver");
diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index 8be8be4..c2fc2f7 100755
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -31,7 +31,6 @@
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
 
diff --git a/drivers/net/tsi108_eth.c b/drivers/net/tsi108_eth.c
index 1aabc91..a059f3d 100644
--- a/drivers/net/tsi108_eth.c
+++ b/drivers/net/tsi108_eth.c
@@ -47,7 +47,6 @@
 #include <linux/rtnetlink.h>
 #include <linux/timer.h>
 #include <linux/platform_device.h>
-#include <linux/etherdevice.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
diff --git a/drivers/net/wireless/ipw2200.h b/drivers/net/wireless/ipw2200.h
index 626a240..9c973b9 100644
--- a/drivers/net/wireless/ipw2200.h
+++ b/drivers/net/wireless/ipw2200.h
@@ -45,7 +45,6 @@
 
 #include <linux/firmware.h>
 #include <linux/wireless.h>
-#include <linux/dma-mapping.h>
 #include <linux/jiffies.h>
 #include <asm/io.h>
 
diff --git a/drivers/net/wireless/zd1211rw/zd_def.h b/drivers/net/wireless/zd1211rw/zd_def.h
index deb99d1..505b4d7 100644
--- a/drivers/net/wireless/zd1211rw/zd_def.h
+++ b/drivers/net/wireless/zd1211rw/zd_def.h
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/device.h>
-#include <linux/kernel.h>
 
 typedef u16 __nocast zd_addr_t;
 
