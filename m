Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYEFH2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYEFH2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYEFH1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:27:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54921 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbYEFH1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:27:47 -0400
Date: Tue, 6 May 2008 09:28:34 +0200
From: Pavel Machek <pavel@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und: some more code removal
Message-ID: <20080506072834.GA4600@elf.ucw.cz>
References: <20080505200927.GA7273@elf.ucw.cz> <1210018631.4181.29.camel@johannes.berg> <20080505202057.GB7273@elf.ucw.cz> <1210022787.8012.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210022787.8012.0.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Remove some more unneccessary code
> > > > 
> > > > ---
> > > > commit 5b251c6315097d5f9ab5d30c43813fe74c1db4e4
> > > > tree 5ca21582f55886d5f0249f7ca139687450024581
> > > > parent e44ccdabb97fa4a6cdc1a95adcad7bcc469d0c16
> > > > author Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> > > > committer Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> > > 
> > > Let me guess, you're using git-am too? :P
> > 
> > No, this is actually all hand-generated ;-).
> 
> You must be very bored ;) The delme.gz patch creates like a million
> empty files :)

Yep, this removes the empty files ;-).

Remove empty files.

---
commit 27d52109134d234d10d1428b898b916a08454c32
tree 11986829aedcd4ac45bb01c3b3b6622a4d49ba67
parent 78b9049df56fbd5fc785b4e7e9c93dbfb8390d2a
author Pavel <pavel@amd.ucw.cz> Tue, 06 May 2008 09:22:29 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 06 May 2008 09:22:29 +0200

 drivers/net/wireless/winbond/Makefile              |   11 +++++------
 .../net/wireless/winbond/winbondport/bssdbase.c    |    0 
 drivers/net/wireless/winbond/winbondport/ds_tkip.c |    0 
 .../wireless/winbond/winbondport/gui_structures.h  |    0 
 drivers/net/wireless/winbond/winbondport/knl.c     |    0 
 drivers/net/wireless/winbond/winbondport/knl.h     |    0 
 .../wireless/winbond/winbondport/linux/Makefile    |    5 ++++-
 .../winbond/winbondport/linux/new_wireless.c       |    0 
 .../winbond/winbondport/linux/new_wireless.h       |    0 
 .../wireless/winbond/winbondport/linux/sysdef.h    |   10 ----------
 .../wireless/winbond/winbondport/linux/teststa.h   |    0 
 .../net/wireless/winbond/winbondport/mlme_assoc.c  |    0 
 .../net/wireless/winbond/winbondport/mlme_auth.c   |    0 
 drivers/net/wireless/winbond/winbondport/mlme_f.h  |    0 
 .../net/wireless/winbond/winbondport/mlmetask.c    |    0 
 drivers/net/wireless/winbond/winbondport/roam_f.h  |    0 
 drivers/net/wireless/winbond/winbondport/roam_s.h  |    0 
 .../net/wireless/winbond/winbondport/roamtask.c    |    0 
 drivers/net/wireless/winbond/winbondport/scan_f.h  |    0 
 .../net/wireless/winbond/winbondport/scan_probe.c  |    0 
 .../net/wireless/winbond/winbondport/scantask.c    |    0 
 drivers/net/wireless/winbond/winbondport/sme_f.h   |    0 
 drivers/net/wireless/winbond/winbondport/smetask.c |    0 
 drivers/net/wireless/winbond/winbondport/wblinux.c |    1 -
 drivers/net/wireless/winbond/winbondport/wbndis.c  |    0 
 .../net/wireless/winbond/winbondport/wbndis51.c    |    0 
 .../net/wireless/winbond/winbondport/wbndis51_f.h  |    0 
 .../net/wireless/winbond/winbondport/wbndis51_s.h  |    0 
 .../wireless/winbond/winbondport/wbndis_entry.c    |    0 
 .../net/wireless/winbond/winbondport/wbndis_f.h    |    0 
 .../net/wireless/winbond/winbondport/wbndis_s.h    |    0 
 .../net/wireless/winbond/winbondport/wpa/4Way.c    |    0 
 .../net/wireless/winbond/winbondport/wpa/4Way.h    |    0 
 .../winbond/winbondport/wpa/Adapter_Bridge.c       |    0 
 .../winbond/winbondport/wpa/Adapter_Bridge.h       |    0 
 .../wireless/winbond/winbondport/wpa/EapolKey.h    |    0 
 .../winbond/winbondport/wpa/Ndis_Structure.h       |    0 
 .../wireless/winbond/winbondport/wpa/STLFunction.c |    0 
 .../wireless/winbond/winbondport/wpa/STLFunction.h |    0 
 drivers/net/wireless/winbond/winbondport/wpa/aes.c |    0 
 drivers/net/wireless/winbond/winbondport/wpa/aes.h |    0 
 .../wireless/winbond/winbondport/wpa/aes_wrap.c    |    0 
 .../wireless/winbond/winbondport/wpa/aes_wrap.h    |    0 
 drivers/net/wireless/winbond/winbondport/wpa/eap.c |    0 
 drivers/net/wireless/winbond/winbondport/wpa/eap.h |    0 
 .../wireless/winbond/winbondport/wpa/hmac_md5.c    |    0 
 .../wireless/winbond/winbondport/wpa/hmac_md5.h    |    0 
 .../wireless/winbond/winbondport/wpa/hmac_sha1.c   |    0 
 .../wireless/winbond/winbondport/wpa/hmac_sha1.h   |    0 
 drivers/net/wireless/winbond/winbondport/wpa/md5.c |    0 
 drivers/net/wireless/winbond/winbondport/wpa/md5.h |    0 
 .../wireless/winbond/winbondport/wpa/passphrase.c  |    0 
 .../wireless/winbond/winbondport/wpa/passphrase.h  |    0 
 drivers/net/wireless/winbond/winbondport/wpa/prf.c |    0 
 drivers/net/wireless/winbond/winbondport/wpa/prf.h |    0 
 drivers/net/wireless/winbond/winbondport/wpa/rc4.c |    0 
 drivers/net/wireless/winbond/winbondport/wpa/rc4.h |    0 
 drivers/net/wireless/winbond/winbondport/wpa/sha.h |    0 
 .../net/wireless/winbond/winbondport/wpa/sha1.c    |    0 
 .../net/wireless/winbond/winbondport/wpa/wb_wpa.h  |    0 
 .../winbond/winbondport/wpa/wireless_reference.h   |    0 
 61 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/winbond/Makefile b/drivers/net/wireless/winbond/Makefile
index 6c90a4b..4682dd1 100644
--- a/drivers/net/wireless/winbond/Makefile
+++ b/drivers/net/wireless/winbond/Makefile
@@ -4,12 +4,11 @@
 obj-m := w35und.o
 
 w35und-objs := $(DRIVER_DIR)/wbusb.o $(DRIVER_DIR)/wb35reg.o $(DRIVER_DIR)/wb35rx.o $(DRIVER_DIR)/wb35tx.o \
-	$(DRIVER_DIR)/new_wireless.o \
-	$(BASE_DIR)/bssdbase.o $(BASE_DIR)/ds_tkip.o $(BASE_DIR)/knl.o $(BASE_DIR)/mds.o \
-	$(BASE_DIR)/mlme_assoc.o $(BASE_DIR)/mlme_auth.o $(BASE_DIR)/mlmetask.o $(BASE_DIR)/mlmetxrx.o \
-	$(BASE_DIR)/mto.o $(BASE_DIR)/phy_calibration.o $(BASE_DIR)/reg.o $(BASE_DIR)/roamtask.o \
-	$(BASE_DIR)/rxisr.o $(BASE_DIR)/scan_probe.o $(BASE_DIR)/scantask.o \
-	$(BASE_DIR)/sme_api.o $(BASE_DIR)/smetask.o $(BASE_DIR)/wbhal.o $(BASE_DIR)/wblinux.o  \
+	$(BASE_DIR)/mds.o \
+	$(BASE_DIR)/mlmetxrx.o \
+	$(BASE_DIR)/mto.o $(BASE_DIR)/phy_calibration.o $(BASE_DIR)/reg.o \
+	$(BASE_DIR)/rxisr.o \
+	$(BASE_DIR)/sme_api.o $(BASE_DIR)/wbhal.o $(BASE_DIR)/wblinux.o  \
 
 
 obj-$(CONFIG_W35UND) += w35und.o
diff --git a/drivers/net/wireless/winbond/winbondport/bssdbase.c b/drivers/net/wireless/winbond/winbondport/bssdbase.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/ds_tkip.c b/drivers/net/wireless/winbond/winbondport/ds_tkip.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/gui_structures.h b/drivers/net/wireless/winbond/winbondport/gui_structures.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/knl.c b/drivers/net/wireless/winbond/winbondport/knl.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/knl.h b/drivers/net/wireless/winbond/winbondport/knl.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/linux/Makefile b/drivers/net/wireless/winbond/winbondport/linux/Makefile
index cf89114..4aadb4f 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/Makefile
+++ b/drivers/net/wireless/winbond/winbondport/linux/Makefile
@@ -9,13 +9,16 @@ #  Linux 2.6 driver for IS89C35D 802.11 
 #
 #=========================================================================
 
+
+# This is not used for build when the wifi module is build into kernel
+# 
 	KERNELDIR := /lib/modules/$(shell uname -r)/build
 	PWD := $(shell pwd)
 	WPA_DIR=../wpa
 
 obj-m := w35und.o
 
-w35und-objs := new_wireless.o wbusb.o wb35reg.o wb35rx.o wb35tx.o\
+w35und-objs := wbusb.o wb35reg.o wb35rx.o wb35tx.o\
 	../bssdbase.o ../ds_tkip.o ../knl.o ../mds.o ../mlme_assoc.o ../mlme_auth.o ../mlmetask.o ../mlmetxrx.o \
 	../mto.o ../phy_calibration.o ../reg.o ../roamtask.o ../rxisr.o ../scan_probe.o ../scantask.o \
 	../sme_api.o ../smetask.o ../wbhal.o ../wblinux.o \
diff --git a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.h b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/linux/sysdef.h b/drivers/net/wireless/winbond/winbondport/linux/sysdef.h
index c844d28..8507c06 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/sysdef.h
+++ b/drivers/net/wireless/winbond/winbondport/linux/sysdef.h
@@ -49,33 +49,23 @@ #include "../sme_s.h"
 #include "../scan_s.h"
 #include "../mds_s.h"
 #include "../mlme_s.h"
-#include "../roam_s.h"
 #include "../bssdscpt.h"
 #include "../sme_api.h"
 #include "../gl_80211.h"
 #include "../mto.h"
 #include "../wblinux_s.h"
 #include "../wbhal_s.h"
-#include "teststa.h"
 
 
-#include "../wpa/wb_wpa.h" // 20060802
-
 #include "../adapter.h"
 
 #include "../mlme_mib.h"
-#include "../knl.h"
-#include "../sme_f.h"
-#include "../mlme_f.h"
-#include "../scan_f.h"
 #include "../mds_f.h"
 #include "../bss_f.h"
 #include "../mlmetxrx_f.h"
-#include "../roam_f.h"
 #include "../mto_f.h"
 #include "../wbhal_f.h"
 #include "../wblinux_f.h"
-#include "new_wireless.h"
 // Kernel Timer resolution, NDIS is 10ms, 10000us
 #define MIN_TIMEOUT_VAL	(10) //ms
 
diff --git a/drivers/net/wireless/winbond/winbondport/linux/teststa.h b/drivers/net/wireless/winbond/winbondport/linux/teststa.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_assoc.c b/drivers/net/wireless/winbond/winbondport/mlme_assoc.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_auth.c b/drivers/net/wireless/winbond/winbondport/mlme_auth.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_f.h b/drivers/net/wireless/winbond/winbondport/mlme_f.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/mlmetask.c b/drivers/net/wireless/winbond/winbondport/mlmetask.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/roam_f.h b/drivers/net/wireless/winbond/winbondport/roam_f.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/roam_s.h b/drivers/net/wireless/winbond/winbondport/roam_s.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/roamtask.c b/drivers/net/wireless/winbond/winbondport/roamtask.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/scan_f.h b/drivers/net/wireless/winbond/winbondport/scan_f.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/scan_probe.c b/drivers/net/wireless/winbond/winbondport/scan_probe.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/scantask.c b/drivers/net/wireless/winbond/winbondport/scantask.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/sme_f.h b/drivers/net/wireless/winbond/winbondport/sme_f.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/smetask.c b/drivers/net/wireless/winbond/winbondport/smetask.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index d2b86cb..ea96135 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -9,7 +9,6 @@
 //
 //============================================================================
 #include "os_common.h"
-#include "linux/new_wireless.h"
 
 u32
 WBLINUX_MemoryAlloc(void* *VirtualAddress, u32 Length)
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis.c b/drivers/net/wireless/winbond/winbondport/wbndis.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis51.c b/drivers/net/wireless/winbond/winbondport/wbndis51.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis51_f.h b/drivers/net/wireless/winbond/winbondport/wbndis51_f.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis51_s.h b/drivers/net/wireless/winbond/winbondport/wbndis51_s.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis_entry.c b/drivers/net/wireless/winbond/winbondport/wbndis_entry.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis_f.h b/drivers/net/wireless/winbond/winbondport/wbndis_f.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis_s.h b/drivers/net/wireless/winbond/winbondport/wbndis_s.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/4Way.c b/drivers/net/wireless/winbond/winbondport/wpa/4Way.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/4Way.h b/drivers/net/wireless/winbond/winbondport/wpa/4Way.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/Adapter_Bridge.c b/drivers/net/wireless/winbond/winbondport/wpa/Adapter_Bridge.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/Adapter_Bridge.h b/drivers/net/wireless/winbond/winbondport/wpa/Adapter_Bridge.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/EapolKey.h b/drivers/net/wireless/winbond/winbondport/wpa/EapolKey.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/Ndis_Structure.h b/drivers/net/wireless/winbond/winbondport/wpa/Ndis_Structure.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/STLFunction.c b/drivers/net/wireless/winbond/winbondport/wpa/STLFunction.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/STLFunction.h b/drivers/net/wireless/winbond/winbondport/wpa/STLFunction.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/aes.c b/drivers/net/wireless/winbond/winbondport/wpa/aes.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/aes.h b/drivers/net/wireless/winbond/winbondport/wpa/aes.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/aes_wrap.c b/drivers/net/wireless/winbond/winbondport/wpa/aes_wrap.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/aes_wrap.h b/drivers/net/wireless/winbond/winbondport/wpa/aes_wrap.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/eap.c b/drivers/net/wireless/winbond/winbondport/wpa/eap.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/eap.h b/drivers/net/wireless/winbond/winbondport/wpa/eap.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/hmac_md5.c b/drivers/net/wireless/winbond/winbondport/wpa/hmac_md5.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/hmac_md5.h b/drivers/net/wireless/winbond/winbondport/wpa/hmac_md5.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/hmac_sha1.c b/drivers/net/wireless/winbond/winbondport/wpa/hmac_sha1.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/hmac_sha1.h b/drivers/net/wireless/winbond/winbondport/wpa/hmac_sha1.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/md5.c b/drivers/net/wireless/winbond/winbondport/wpa/md5.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/md5.h b/drivers/net/wireless/winbond/winbondport/wpa/md5.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/passphrase.c b/drivers/net/wireless/winbond/winbondport/wpa/passphrase.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/passphrase.h b/drivers/net/wireless/winbond/winbondport/wpa/passphrase.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/prf.c b/drivers/net/wireless/winbond/winbondport/wpa/prf.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/prf.h b/drivers/net/wireless/winbond/winbondport/wpa/prf.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/rc4.c b/drivers/net/wireless/winbond/winbondport/wpa/rc4.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/rc4.h b/drivers/net/wireless/winbond/winbondport/wpa/rc4.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/sha.h b/drivers/net/wireless/winbond/winbondport/wpa/sha.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/sha1.c b/drivers/net/wireless/winbond/winbondport/wpa/sha1.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/wb_wpa.h b/drivers/net/wireless/winbond/winbondport/wpa/wb_wpa.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/net/wireless/winbond/winbondport/wpa/wireless_reference.h b/drivers/net/wireless/winbond/winbondport/wpa/wireless_reference.h
deleted file mode 100644
index e69de29..0000000




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
