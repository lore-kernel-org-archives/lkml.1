Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbXJ3Jhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbXJ3Jhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbXJ3Jg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:36:26 -0400
Received: from nic2.axis.se ([193.13.178.10]:41017 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691AbXJ3JgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:36:24 -0400
Date: Tue, 30 Oct 2007 10:36:13 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093613.GS11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unused config lines, and add some others that needs to be off
for a succesful compile. This is the minimal set of changes for 2.6.23.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 defconfig |   76 ++++++++++++++++++++++++++------------------------------------
 1 file changed, 33 insertions(+), 43 deletions(-)

--- clean_linux-2.6.23/arch/cris/defconfig	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/defconfig	2007-10-29 14:19:45.000000000 +0100
@@ -276,6 +276,7 @@
 # CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
 # CONFIG_BLK_DEV_UB is not set
 CONFIG_BLK_DEV_RAM=y
@@ -302,16 +303,14 @@
 #
 # ATA/ATAPI/MFM/RLL support
 #
-CONFIG_IDE=y
-CONFIG_BLK_DEV_IDE=y
+# CONFIG_IDE is not set
+# CONFIG_PARIDE is not set
 
 #
 # Please see Documentation/ide.txt for help/info on IDE drives
 #
 # CONFIG_BLK_DEV_IDE_SATA is not set
-CONFIG_BLK_DEV_IDEDISK=y
 # CONFIG_IDEDISK_MULTI_MODE is not set
-CONFIG_BLK_DEV_IDECD=y
 # CONFIG_BLK_DEV_IDETAPE is not set
 # CONFIG_BLK_DEV_IDEFLOPPY is not set
 # CONFIG_IDE_TASK_IOCTL is not set
@@ -321,7 +320,6 @@
 #
 # CONFIG_IDE_GENERIC is not set
 # CONFIG_IDE_ARM is not set
-CONFIG_BLK_DEV_IDEDMA=y
 # CONFIG_IDEDMA_AUTO is not set
 # CONFIG_BLK_DEV_HD is not set
 
@@ -329,6 +327,7 @@
 # SCSI device support
 #
 # CONFIG_SCSI is not set
+# CONFIG_ISCSI_TCP is not set
 
 #
 # IEEE 1394 (FireWire) support
@@ -414,26 +413,11 @@
 # CONFIG_NET_POLL_CONTROLLER is not set
 # CONFIG_HAMRADIO is not set
 # CONFIG_IRDA is not set
-CONFIG_BT=y
-CONFIG_BT_L2CAP=y
-# CONFIG_BT_SCO is not set
-CONFIG_BT_RFCOMM=y
-# CONFIG_BT_RFCOMM_TTY is not set
-CONFIG_BT_BNEP=y
-# CONFIG_BT_BNEP_MC_FILTER is not set
-# CONFIG_BT_BNEP_PROTO_FILTER is not set
-# CONFIG_BT_HIDP is not set
-
-#
-# Bluetooth device drivers
-#
-CONFIG_BT_HCIUSB=y
-# CONFIG_BT_HCIUSB_SCO is not set
-# CONFIG_BT_HCIUART is not set
-# CONFIG_BT_HCIBCM203X is not set
-# CONFIG_BT_HCIBPA10X is not set
-# CONFIG_BT_HCIBFUSB is not set
-# CONFIG_BT_HCIVHCI is not set
+# CONFIG_AF_RXRPC is not set
+# CONFIG_AF_RXRPC_DEBUG is not set
+# CONFIG_BT is not set
+# CONFIG_I2C is not set
+
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -485,31 +469,17 @@
 #
 # Input device support
 #
-CONFIG_INPUT=y
-
-#
-# Userland interfaces
-#
-CONFIG_INPUT_MOUSEDEV=y
-CONFIG_INPUT_MOUSEDEV_PSAUX=y
-CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
-CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
-# CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
-# CONFIG_INPUT_EVDEV is not set
-# CONFIG_INPUT_EVBUG is not set
+# CONFIG_INPUT is not set
 
 #
 # Input I/O drivers
 #
-# CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
 CONFIG_SERIO=y
 # CONFIG_SERIO_I8042 is not set
 # CONFIG_SERIO_SERPORT is not set
-# CONFIG_SERIO_CT82C710 is not set
-CONFIG_SERIO_LIBPS2=y
+# CONFIG_SERIO_LIBPS2 is not set
 # CONFIG_SERIO_RAW is not set
+# CONFIG_GAMEPORT is not set
 
 #
 # Input Device Drivers
@@ -525,6 +495,7 @@
 # CONFIG_MOUSE_SERIAL is not set
 # CONFIG_MOUSE_VSXXXAA is not set
 # CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
 # CONFIG_INPUT_TOUCHSCREEN is not set
 # CONFIG_INPUT_MISC is not set
 
@@ -542,6 +513,8 @@
 #
 # Non-8250 serial port support
 #
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
@@ -559,6 +532,8 @@
 # CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
+# CONFIG_RTC_LIB is not set
+# CONFIG_RTC_CLASS is not set
 
 #
 # Ftape, the floppy tape device driver
@@ -660,7 +635,9 @@
 # CONFIG_NFSD is not set
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -686,9 +663,21 @@
 # CONFIG_SOUND is not set
 
 #
+# Generic devices
+#
+# CONFIG_SND_MPU401_UART is not set
+# CONFIG_SND_DUMMY is not set
+# CONFIG_SND_VIRMIDI is not set
+# CONFIG_SND_MTPAV is not set
+# CONFIG_SND_SERIAL_U16550 is not set
+# CONFIG_SND_MPU401 is not set
+
+#
 # PCCARD (PCMCIA/CardBus) support
 #
 # CONFIG_PCCARD is not set
+# CONFIG_PARPORT_PC_PCMCIA is not set
+# CONFIG_NET_PCMCIA is not set
 
 #
 # PC-card bridges
@@ -734,6 +723,7 @@
 # USB Input Devices
 #
 # CONFIG_USB_HID is not set
+# HID_SUPPORT is not set
 
 #
 # USB HID Boot Protocol drivers
@@ -829,7 +819,7 @@
 
 #
 # Hardware crypto devices
-#
+# CONFIG_CRYPTO_HW is not set
 
 #
 # Library routines

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
