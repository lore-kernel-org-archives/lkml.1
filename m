Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYJUTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYJUTF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYJUTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:05:12 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:61073 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYJUTFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=R0u1rLqmRESGrZ5ITZ0Kpf75b5uk0+lt5uheBXY+lZnBPV+6aO7/YI8e8mPvVVs1co
         ff/vCRN74Dc14s/rLhlneoQC6kBVFn+qTqDvJ9vgdCH4i9pfflhCuY9dmAv+antikHWZ
         /k7SH0+TBUD1Odi5ua3YE5evokuvY13fVDAXE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates #4
Date: Tue, 21 Oct 2008 21:00:52 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810212100.52985.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove needless/confusing subdirs from drivers/ide/.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Makefile                    |   84 +++++++++++++++++++++++--------
 drivers/ide/{pci => }/aec62xx.c         |    0 
 drivers/ide/{legacy => }/ali14xx.c      |    0 
 drivers/ide/{pci => }/alim15x3.c        |    0 
 drivers/ide/{pci => }/amd74xx.c         |    0 
 drivers/ide/arm/Makefile                |   10 ----
 drivers/ide/{pci => }/atiixp.c          |    0 
 drivers/ide/{mips => }/au1xxx-ide.c     |    0 
 drivers/ide/{legacy => }/buddha.c       |    0 
 drivers/ide/{pci => }/cmd640.c          |    0 
 drivers/ide/{pci => }/cmd64x.c          |    0 
 drivers/ide/{pci => }/cs5520.c          |    0 
 drivers/ide/{pci => }/cs5530.c          |    0 
 drivers/ide/{pci => }/cs5535.c          |    0 
 drivers/ide/{pci => }/cy82c693.c        |    0 
 drivers/ide/{pci => }/delkin_cb.c       |    0 
 drivers/ide/{legacy => }/dtc2278.c      |    0 
 drivers/ide/{legacy => }/falconide.c    |    0 
 drivers/ide/{legacy => }/gayle.c        |    0 
 drivers/ide/{pci => }/generic.c         |    0 
 drivers/ide/h8300/Makefile              |    2 -
 drivers/ide/{pci => }/hpt366.c          |    0 
 drivers/ide/{legacy => }/ht6560b.c      |    0 
 drivers/ide/{arm => }/icside.c          |    0 
 drivers/ide/{legacy => }/ide-4drives.c  |    0 
 drivers/ide/{legacy => }/ide-cs.c       |    0 
 drivers/ide/{h8300 => }/ide-h8300.c     |    0 
 drivers/ide/{arm => }/ide_arm.c         |    0 
 drivers/ide/{legacy => }/ide_platform.c |    0 
 drivers/ide/{pci => }/it8213.c          |    0 
 drivers/ide/{pci => }/it821x.c          |    0 
 drivers/ide/{pci => }/jmicron.c         |    0 
 drivers/ide/legacy/Makefile             |   25 ---------
 drivers/ide/{legacy => }/macide.c       |    0 
 drivers/ide/mips/Makefile               |    3 -
 drivers/ide/{pci => }/ns87415.c         |    0 
 drivers/ide/{pci => }/opti621.c         |    0 
 drivers/ide/{arm => }/palm_bk3710.c     |    0 
 drivers/ide/pci/Makefile                |   43 ----------------
 drivers/ide/{pci => }/pdc202xx_new.c    |    0 
 drivers/ide/{pci => }/pdc202xx_old.c    |    0 
 drivers/ide/{pci => }/piix.c            |    0 
 drivers/ide/{ppc => }/pmac.c            |    0 
 drivers/ide/ppc/Makefile                |    2 -
 drivers/ide/{legacy => }/q40ide.c       |    0 
 drivers/ide/{legacy => }/qd65xx.c       |    0 
 drivers/ide/{legacy => }/qd65xx.h       |    0 
 drivers/ide/{arm => }/rapide.c          |    0 
 drivers/ide/{pci => }/rz1000.c          |    0 
 drivers/ide/{pci => }/sc1200.c          |    0 
 drivers/ide/{pci => }/scc_pata.c        |    0 
 drivers/ide/{pci => }/serverworks.c     |    0 
 drivers/ide/{pci => }/sgiioc4.c         |    0 
 drivers/ide/{pci => }/siimage.c         |    0 
 drivers/ide/{pci => }/sis5513.c         |    0 
 drivers/ide/{pci => }/sl82c105.c        |    0 
 drivers/ide/{pci => }/slc90e66.c        |    0 
 drivers/ide/{pci => }/tc86c001.c        |    0 
 drivers/ide/{pci => }/triflex.c         |    0 
 drivers/ide/{pci => }/trm290.c          |    0 
 drivers/ide/{legacy => }/umc8672.c      |    0 
 drivers/ide/{pci => }/via82cxxx.c       |    0 
 62 files changed, 63 insertions(+), 106 deletions(-)
 rename drivers/ide/{pci => }/aec62xx.c (100%)
 rename drivers/ide/{legacy => }/ali14xx.c (100%)
 rename drivers/ide/{pci => }/alim15x3.c (100%)
 rename drivers/ide/{pci => }/amd74xx.c (100%)
 delete mode 100644 drivers/ide/arm/Makefile
 rename drivers/ide/{pci => }/atiixp.c (100%)
 rename drivers/ide/{mips => }/au1xxx-ide.c (100%)
 rename drivers/ide/{legacy => }/buddha.c (100%)
 rename drivers/ide/{pci => }/cmd640.c (100%)
 rename drivers/ide/{pci => }/cmd64x.c (100%)
 rename drivers/ide/{pci => }/cs5520.c (100%)
 rename drivers/ide/{pci => }/cs5530.c (100%)
 rename drivers/ide/{pci => }/cs5535.c (100%)
 rename drivers/ide/{pci => }/cy82c693.c (100%)
 rename drivers/ide/{pci => }/delkin_cb.c (100%)
 rename drivers/ide/{legacy => }/dtc2278.c (100%)
 rename drivers/ide/{legacy => }/falconide.c (100%)
 rename drivers/ide/{legacy => }/gayle.c (100%)
 rename drivers/ide/{pci => }/generic.c (100%)
 delete mode 100644 drivers/ide/h8300/Makefile
 rename drivers/ide/{pci => }/hpt366.c (100%)
 rename drivers/ide/{legacy => }/ht6560b.c (100%)
 rename drivers/ide/{arm => }/icside.c (100%)
 rename drivers/ide/{legacy => }/ide-4drives.c (100%)
 rename drivers/ide/{legacy => }/ide-cs.c (100%)
 rename drivers/ide/{h8300 => }/ide-h8300.c (100%)
 rename drivers/ide/{arm => }/ide_arm.c (100%)
 rename drivers/ide/{legacy => }/ide_platform.c (100%)
 rename drivers/ide/{pci => }/it8213.c (100%)
 rename drivers/ide/{pci => }/it821x.c (100%)
 rename drivers/ide/{pci => }/jmicron.c (100%)
 delete mode 100644 drivers/ide/legacy/Makefile
 rename drivers/ide/{legacy => }/macide.c (100%)
 delete mode 100644 drivers/ide/mips/Makefile
 rename drivers/ide/{pci => }/ns87415.c (100%)
 rename drivers/ide/{pci => }/opti621.c (100%)
 rename drivers/ide/{arm => }/palm_bk3710.c (100%)
 delete mode 100644 drivers/ide/pci/Makefile
 rename drivers/ide/{pci => }/pdc202xx_new.c (100%)
 rename drivers/ide/{pci => }/pdc202xx_old.c (100%)
 rename drivers/ide/{pci => }/piix.c (100%)
 rename drivers/ide/{ppc => }/pmac.c (100%)
 delete mode 100644 drivers/ide/ppc/Makefile
 rename drivers/ide/{legacy => }/q40ide.c (100%)
 rename drivers/ide/{legacy => }/qd65xx.c (100%)
 rename drivers/ide/{legacy => }/qd65xx.h (100%)
 rename drivers/ide/{arm => }/rapide.c (100%)
 rename drivers/ide/{pci => }/rz1000.c (100%)
 rename drivers/ide/{pci => }/sc1200.c (100%)
 rename drivers/ide/{pci => }/scc_pata.c (100%)
 rename drivers/ide/{pci => }/serverworks.c (100%)
 rename drivers/ide/{pci => }/sgiioc4.c (100%)
 rename drivers/ide/{pci => }/siimage.c (100%)
 rename drivers/ide/{pci => }/sis5513.c (100%)
 rename drivers/ide/{pci => }/sl82c105.c (100%)
 rename drivers/ide/{pci => }/slc90e66.c (100%)
 rename drivers/ide/{pci => }/tc86c001.c (100%)
 rename drivers/ide/{pci => }/triflex.c (100%)
 rename drivers/ide/{pci => }/trm290.c (100%)
 rename drivers/ide/{legacy => }/umc8672.c (100%)
 rename drivers/ide/{pci => }/via82cxxx.c (100%)


Bartlomiej Zolnierkiewicz (1):
      ide: remove useless subdirs from drivers/ide/


diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 093d324..9cf92ac 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -18,22 +18,66 @@ ide-core-$(CONFIG_BLK_DEV_IDEACPI)	+= ide-acpi.o
 
 obj-$(CONFIG_IDE)			+= ide-core.o
 
-ifeq ($(CONFIG_IDE_ARM), y)
-	ide-arm-core-y += arm/ide_arm.o
-	obj-y += ide-arm-core.o
-endif
-
-obj-$(CONFIG_IDE)			+= legacy/ pci/
+obj-$(CONFIG_IDE_ARM)			+= ide_arm.o
+
+obj-$(CONFIG_BLK_DEV_ALI14XX)		+= ali14xx.o
+obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
+obj-$(CONFIG_BLK_DEV_DTC2278)		+= dtc2278.o
+obj-$(CONFIG_BLK_DEV_HT6560B)		+= ht6560b.o
+obj-$(CONFIG_BLK_DEV_QD65XX)		+= qd65xx.o
+obj-$(CONFIG_BLK_DEV_4DRIVES)		+= ide-4drives.o
+
+obj-$(CONFIG_BLK_DEV_GAYLE)		+= gayle.o
+obj-$(CONFIG_BLK_DEV_FALCON_IDE)	+= falconide.o
+obj-$(CONFIG_BLK_DEV_MAC_IDE)		+= macide.o
+obj-$(CONFIG_BLK_DEV_Q40IDE)		+= q40ide.o
+obj-$(CONFIG_BLK_DEV_BUDDHA)		+= buddha.o
+
+obj-$(CONFIG_BLK_DEV_AEC62XX)		+= aec62xx.o
+obj-$(CONFIG_BLK_DEV_ALI15X3)		+= alim15x3.o
+obj-$(CONFIG_BLK_DEV_AMD74XX)		+= amd74xx.o
+obj-$(CONFIG_BLK_DEV_ATIIXP)		+= atiixp.o
+obj-$(CONFIG_BLK_DEV_CELLEB)		+= scc_pata.o
+obj-$(CONFIG_BLK_DEV_CMD64X)		+= cmd64x.o
+obj-$(CONFIG_BLK_DEV_CS5520)		+= cs5520.o
+obj-$(CONFIG_BLK_DEV_CS5530)		+= cs5530.o
+obj-$(CONFIG_BLK_DEV_CS5535)		+= cs5535.o
+obj-$(CONFIG_BLK_DEV_SC1200)		+= sc1200.o
+obj-$(CONFIG_BLK_DEV_CY82C693)		+= cy82c693.o
+obj-$(CONFIG_BLK_DEV_DELKIN)		+= delkin_cb.o
+obj-$(CONFIG_BLK_DEV_HPT366)		+= hpt366.o
+obj-$(CONFIG_BLK_DEV_IT8213)		+= it8213.o
+obj-$(CONFIG_BLK_DEV_IT821X)		+= it821x.o
+obj-$(CONFIG_BLK_DEV_JMICRON)		+= jmicron.o
+obj-$(CONFIG_BLK_DEV_NS87415)		+= ns87415.o
+obj-$(CONFIG_BLK_DEV_OPTI621)		+= opti621.o
+obj-$(CONFIG_BLK_DEV_PDC202XX_OLD)	+= pdc202xx_old.o
+obj-$(CONFIG_BLK_DEV_PDC202XX_NEW)	+= pdc202xx_new.o
+obj-$(CONFIG_BLK_DEV_PIIX)		+= piix.o
+obj-$(CONFIG_BLK_DEV_RZ1000)		+= rz1000.o
+obj-$(CONFIG_BLK_DEV_SVWKS)		+= serverworks.o
+obj-$(CONFIG_BLK_DEV_SGIIOC4)		+= sgiioc4.o
+obj-$(CONFIG_BLK_DEV_SIIMAGE)		+= siimage.o
+obj-$(CONFIG_BLK_DEV_SIS5513)		+= sis5513.o
+obj-$(CONFIG_BLK_DEV_SL82C105)		+= sl82c105.o
+obj-$(CONFIG_BLK_DEV_SLC90E66)		+= slc90e66.o
+obj-$(CONFIG_BLK_DEV_TC86C001)		+= tc86c001.o
+obj-$(CONFIG_BLK_DEV_TRIFLEX)		+= triflex.o
+obj-$(CONFIG_BLK_DEV_TRM290)		+= trm290.o
+obj-$(CONFIG_BLK_DEV_VIA82CXXX)		+= via82cxxx.o
+
+# Must appear at the end of the block
+obj-$(CONFIG_BLK_DEV_GENERIC)		+= ide-pci-generic.o
+ide-pci-generic-y			+= generic.o
 
 obj-$(CONFIG_IDEPCI_PCIBUS_ORDER)	+= ide-scan-pci.o
 
-ifeq ($(CONFIG_BLK_DEV_CMD640), y)
-	cmd640-core-y += pci/cmd640.o
-	obj-y += cmd640-core.o
-endif
+obj-$(CONFIG_BLK_DEV_CMD640)		+= cmd640.o
+
+obj-$(CONFIG_BLK_DEV_IDE_PMAC)		+= pmac.o
+
+obj-$(CONFIG_IDE_H8300)			+= ide-h8300.o
 
-obj-$(CONFIG_IDE)			+= ppc/
-obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
@@ -58,14 +102,12 @@ obj-$(CONFIG_IDE_GD)			+= ide-gd_mod.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
 obj-$(CONFIG_BLK_DEV_IDETAPE)		+= ide-tape.o
 
-ifeq ($(CONFIG_BLK_DEV_IDECS), y)
-	ide-cs-core-y += legacy/ide-cs.o
-	obj-y += ide-cs-core.o
-endif
+obj-$(CONFIG_BLK_DEV_IDECS)		+= ide-cs.o
 
-ifeq ($(CONFIG_BLK_DEV_PLATFORM), y)
-	ide-platform-core-y += legacy/ide_platform.o
-	obj-y += ide-platform-core.o
-endif
+obj-$(CONFIG_BLK_DEV_PLATFORM)		+= ide_platform.o
+
+obj-$(CONFIG_BLK_DEV_IDE_ICSIDE)	+= icside.o
+obj-$(CONFIG_BLK_DEV_IDE_RAPIDE)	+= rapide.o
+obj-$(CONFIG_BLK_DEV_PALMCHIP_BK3710)	+= palm_bk3710.o
 
-obj-$(CONFIG_IDE)			+= arm/ mips/
+obj-$(CONFIG_BLK_DEV_IDE_AU1XXX)	+= au1xxx-ide.o
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/aec62xx.c
similarity index 100%
rename from drivers/ide/pci/aec62xx.c
rename to drivers/ide/aec62xx.c
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/ali14xx.c
similarity index 100%
rename from drivers/ide/legacy/ali14xx.c
rename to drivers/ide/ali14xx.c
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/alim15x3.c
similarity index 100%
rename from drivers/ide/pci/alim15x3.c
rename to drivers/ide/alim15x3.c
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/amd74xx.c
similarity index 100%
rename from drivers/ide/pci/amd74xx.c
rename to drivers/ide/amd74xx.c
diff --git a/drivers/ide/arm/Makefile b/drivers/ide/arm/Makefile
deleted file mode 100644
index 5bc2605..0000000
--- a/drivers/ide/arm/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-
-obj-$(CONFIG_BLK_DEV_IDE_ICSIDE)	+= icside.o
-obj-$(CONFIG_BLK_DEV_IDE_RAPIDE)	+= rapide.o
-obj-$(CONFIG_BLK_DEV_PALMCHIP_BK3710)	+= palm_bk3710.o
-
-ifeq ($(CONFIG_IDE_ARM), m)
-	obj-m += ide_arm.o
-endif
-
-EXTRA_CFLAGS	:= -Idrivers/ide
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/atiixp.c
similarity index 100%
rename from drivers/ide/pci/atiixp.c
rename to drivers/ide/atiixp.c
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
similarity index 100%
rename from drivers/ide/mips/au1xxx-ide.c
rename to drivers/ide/au1xxx-ide.c
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/buddha.c
similarity index 100%
rename from drivers/ide/legacy/buddha.c
rename to drivers/ide/buddha.c
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/cmd640.c
similarity index 100%
rename from drivers/ide/pci/cmd640.c
rename to drivers/ide/cmd640.c
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/cmd64x.c
similarity index 100%
rename from drivers/ide/pci/cmd64x.c
rename to drivers/ide/cmd64x.c
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/cs5520.c
similarity index 100%
rename from drivers/ide/pci/cs5520.c
rename to drivers/ide/cs5520.c
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/cs5530.c
similarity index 100%
rename from drivers/ide/pci/cs5530.c
rename to drivers/ide/cs5530.c
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/cs5535.c
similarity index 100%
rename from drivers/ide/pci/cs5535.c
rename to drivers/ide/cs5535.c
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/cy82c693.c
similarity index 100%
rename from drivers/ide/pci/cy82c693.c
rename to drivers/ide/cy82c693.c
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/delkin_cb.c
similarity index 100%
rename from drivers/ide/pci/delkin_cb.c
rename to drivers/ide/delkin_cb.c
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/dtc2278.c
similarity index 100%
rename from drivers/ide/legacy/dtc2278.c
rename to drivers/ide/dtc2278.c
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/falconide.c
similarity index 100%
rename from drivers/ide/legacy/falconide.c
rename to drivers/ide/falconide.c
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/gayle.c
similarity index 100%
rename from drivers/ide/legacy/gayle.c
rename to drivers/ide/gayle.c
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/generic.c
similarity index 100%
rename from drivers/ide/pci/generic.c
rename to drivers/ide/generic.c
diff --git a/drivers/ide/h8300/Makefile b/drivers/ide/h8300/Makefile
deleted file mode 100644
index 5eba16f..0000000
--- a/drivers/ide/h8300/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-
-obj-$(CONFIG_IDE_H8300)			+= ide-h8300.o
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/hpt366.c
similarity index 100%
rename from drivers/ide/pci/hpt366.c
rename to drivers/ide/hpt366.c
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/ht6560b.c
similarity index 100%
rename from drivers/ide/legacy/ht6560b.c
rename to drivers/ide/ht6560b.c
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/icside.c
similarity index 100%
rename from drivers/ide/arm/icside.c
rename to drivers/ide/icside.c
diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/ide-4drives.c
similarity index 100%
rename from drivers/ide/legacy/ide-4drives.c
rename to drivers/ide/ide-4drives.c
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/ide-cs.c
similarity index 100%
rename from drivers/ide/legacy/ide-cs.c
rename to drivers/ide/ide-cs.c
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/ide-h8300.c
similarity index 100%
rename from drivers/ide/h8300/ide-h8300.c
rename to drivers/ide/ide-h8300.c
diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/ide_arm.c
similarity index 100%
rename from drivers/ide/arm/ide_arm.c
rename to drivers/ide/ide_arm.c
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/ide_platform.c
similarity index 100%
rename from drivers/ide/legacy/ide_platform.c
rename to drivers/ide/ide_platform.c
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/it8213.c
similarity index 100%
rename from drivers/ide/pci/it8213.c
rename to drivers/ide/it8213.c
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/it821x.c
similarity index 100%
rename from drivers/ide/pci/it821x.c
rename to drivers/ide/it821x.c
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/jmicron.c
similarity index 100%
rename from drivers/ide/pci/jmicron.c
rename to drivers/ide/jmicron.c
diff --git a/drivers/ide/legacy/Makefile b/drivers/ide/legacy/Makefile
deleted file mode 100644
index 6939329..0000000
--- a/drivers/ide/legacy/Makefile
+++ /dev/null
@@ -1,25 +0,0 @@
-
-# link order is important here
-
-obj-$(CONFIG_BLK_DEV_ALI14XX)		+= ali14xx.o
-obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
-obj-$(CONFIG_BLK_DEV_DTC2278)		+= dtc2278.o
-obj-$(CONFIG_BLK_DEV_HT6560B)		+= ht6560b.o
-obj-$(CONFIG_BLK_DEV_QD65XX)		+= qd65xx.o
-obj-$(CONFIG_BLK_DEV_4DRIVES)		+= ide-4drives.o
-
-obj-$(CONFIG_BLK_DEV_GAYLE)		+= gayle.o
-obj-$(CONFIG_BLK_DEV_FALCON_IDE)	+= falconide.o
-obj-$(CONFIG_BLK_DEV_MAC_IDE)		+= macide.o
-obj-$(CONFIG_BLK_DEV_Q40IDE)		+= q40ide.o
-obj-$(CONFIG_BLK_DEV_BUDDHA)		+= buddha.o
-
-ifeq ($(CONFIG_BLK_DEV_IDECS), m)
-	obj-m += ide-cs.o
-endif
-
-ifeq ($(CONFIG_BLK_DEV_PLATFORM), m)
-	obj-m += ide_platform.o
-endif
-
-EXTRA_CFLAGS	:= -Idrivers/ide
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/macide.c
similarity index 100%
rename from drivers/ide/legacy/macide.c
rename to drivers/ide/macide.c
diff --git a/drivers/ide/mips/Makefile b/drivers/ide/mips/Makefile
deleted file mode 100644
index 5873fa0..0000000
--- a/drivers/ide/mips/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-obj-$(CONFIG_BLK_DEV_IDE_AU1XXX)	+= au1xxx-ide.o
-
-EXTRA_CFLAGS    := -Idrivers/ide
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/ns87415.c
similarity index 100%
rename from drivers/ide/pci/ns87415.c
rename to drivers/ide/ns87415.c
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/opti621.c
similarity index 100%
rename from drivers/ide/pci/opti621.c
rename to drivers/ide/opti621.c
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/palm_bk3710.c
similarity index 100%
rename from drivers/ide/arm/palm_bk3710.c
rename to drivers/ide/palm_bk3710.c
diff --git a/drivers/ide/pci/Makefile b/drivers/ide/pci/Makefile
deleted file mode 100644
index ab44a1f..0000000
--- a/drivers/ide/pci/Makefile
+++ /dev/null
@@ -1,43 +0,0 @@
-
-obj-$(CONFIG_BLK_DEV_AEC62XX)		+= aec62xx.o
-obj-$(CONFIG_BLK_DEV_ALI15X3)		+= alim15x3.o
-obj-$(CONFIG_BLK_DEV_AMD74XX)		+= amd74xx.o
-obj-$(CONFIG_BLK_DEV_ATIIXP)		+= atiixp.o
-obj-$(CONFIG_BLK_DEV_CELLEB)		+= scc_pata.o
-obj-$(CONFIG_BLK_DEV_CMD64X)		+= cmd64x.o
-obj-$(CONFIG_BLK_DEV_CS5520)		+= cs5520.o
-obj-$(CONFIG_BLK_DEV_CS5530)		+= cs5530.o
-obj-$(CONFIG_BLK_DEV_CS5535)		+= cs5535.o
-obj-$(CONFIG_BLK_DEV_SC1200)		+= sc1200.o
-obj-$(CONFIG_BLK_DEV_CY82C693)		+= cy82c693.o
-obj-$(CONFIG_BLK_DEV_DELKIN)		+= delkin_cb.o
-obj-$(CONFIG_BLK_DEV_HPT366)		+= hpt366.o
-obj-$(CONFIG_BLK_DEV_IT8213)		+= it8213.o
-obj-$(CONFIG_BLK_DEV_IT821X)		+= it821x.o
-obj-$(CONFIG_BLK_DEV_JMICRON)		+= jmicron.o
-obj-$(CONFIG_BLK_DEV_NS87415)		+= ns87415.o
-obj-$(CONFIG_BLK_DEV_OPTI621)		+= opti621.o
-obj-$(CONFIG_BLK_DEV_PDC202XX_OLD)	+= pdc202xx_old.o
-obj-$(CONFIG_BLK_DEV_PDC202XX_NEW)	+= pdc202xx_new.o
-obj-$(CONFIG_BLK_DEV_PIIX)		+= piix.o
-obj-$(CONFIG_BLK_DEV_RZ1000)		+= rz1000.o
-obj-$(CONFIG_BLK_DEV_SVWKS)		+= serverworks.o
-obj-$(CONFIG_BLK_DEV_SGIIOC4)		+= sgiioc4.o
-obj-$(CONFIG_BLK_DEV_SIIMAGE)		+= siimage.o
-obj-$(CONFIG_BLK_DEV_SIS5513)		+= sis5513.o
-obj-$(CONFIG_BLK_DEV_SL82C105)		+= sl82c105.o
-obj-$(CONFIG_BLK_DEV_SLC90E66)		+= slc90e66.o
-obj-$(CONFIG_BLK_DEV_TC86C001)		+= tc86c001.o
-obj-$(CONFIG_BLK_DEV_TRIFLEX)		+= triflex.o
-obj-$(CONFIG_BLK_DEV_TRM290)		+= trm290.o
-obj-$(CONFIG_BLK_DEV_VIA82CXXX)		+= via82cxxx.o
-
-# Must appear at the end of the block
-obj-$(CONFIG_BLK_DEV_GENERIC)		+= ide-pci-generic.o
-ide-pci-generic-y			+= generic.o
-
-ifeq ($(CONFIG_BLK_DEV_CMD640), m)
-	obj-m += cmd640.o
-endif
-
-EXTRA_CFLAGS	:= -Idrivers/ide
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
similarity index 100%
rename from drivers/ide/pci/pdc202xx_new.c
rename to drivers/ide/pdc202xx_new.c
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
similarity index 100%
rename from drivers/ide/pci/pdc202xx_old.c
rename to drivers/ide/pdc202xx_old.c
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/piix.c
similarity index 100%
rename from drivers/ide/pci/piix.c
rename to drivers/ide/piix.c
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/pmac.c
similarity index 100%
rename from drivers/ide/ppc/pmac.c
rename to drivers/ide/pmac.c
diff --git a/drivers/ide/ppc/Makefile b/drivers/ide/ppc/Makefile
deleted file mode 100644
index 74e52ad..0000000
--- a/drivers/ide/ppc/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-
-obj-$(CONFIG_BLK_DEV_IDE_PMAC)		+= pmac.o
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/q40ide.c
similarity index 100%
rename from drivers/ide/legacy/q40ide.c
rename to drivers/ide/q40ide.c
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/qd65xx.c
similarity index 100%
rename from drivers/ide/legacy/qd65xx.c
rename to drivers/ide/qd65xx.c
diff --git a/drivers/ide/legacy/qd65xx.h b/drivers/ide/qd65xx.h
similarity index 100%
rename from drivers/ide/legacy/qd65xx.h
rename to drivers/ide/qd65xx.h
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/rapide.c
similarity index 100%
rename from drivers/ide/arm/rapide.c
rename to drivers/ide/rapide.c
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/rz1000.c
similarity index 100%
rename from drivers/ide/pci/rz1000.c
rename to drivers/ide/rz1000.c
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/sc1200.c
similarity index 100%
rename from drivers/ide/pci/sc1200.c
rename to drivers/ide/sc1200.c
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/scc_pata.c
similarity index 100%
rename from drivers/ide/pci/scc_pata.c
rename to drivers/ide/scc_pata.c
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/serverworks.c
similarity index 100%
rename from drivers/ide/pci/serverworks.c
rename to drivers/ide/serverworks.c
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/sgiioc4.c
similarity index 100%
rename from drivers/ide/pci/sgiioc4.c
rename to drivers/ide/sgiioc4.c
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/siimage.c
similarity index 100%
rename from drivers/ide/pci/siimage.c
rename to drivers/ide/siimage.c
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/sis5513.c
similarity index 100%
rename from drivers/ide/pci/sis5513.c
rename to drivers/ide/sis5513.c
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/sl82c105.c
similarity index 100%
rename from drivers/ide/pci/sl82c105.c
rename to drivers/ide/sl82c105.c
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/slc90e66.c
similarity index 100%
rename from drivers/ide/pci/slc90e66.c
rename to drivers/ide/slc90e66.c
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/tc86c001.c
similarity index 100%
rename from drivers/ide/pci/tc86c001.c
rename to drivers/ide/tc86c001.c
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/triflex.c
similarity index 100%
rename from drivers/ide/pci/triflex.c
rename to drivers/ide/triflex.c
diff --git a/drivers/ide/pci/trm290.c b/drivers/ide/trm290.c
similarity index 100%
rename from drivers/ide/pci/trm290.c
rename to drivers/ide/trm290.c
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/umc8672.c
similarity index 100%
rename from drivers/ide/legacy/umc8672.c
rename to drivers/ide/umc8672.c
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/via82cxxx.c
similarity index 100%
rename from drivers/ide/pci/via82cxxx.c
rename to drivers/ide/via82cxxx.c
