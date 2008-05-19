Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYESWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYESWEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764913AbYESWC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:02:56 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42272 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764898AbYESWCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:02:52 -0400
Date: Tue, 20 May 2008 01:00:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] USB: remove CVS keywords
Message-ID: <20080519220046.GY17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/usb/core/devices.c           |    2 --
 drivers/usb/core/devio.c             |    2 --
 drivers/usb/gadget/rndis.c           |    2 --
 drivers/usb/gadget/rndis.h           |    2 --
 drivers/usb/misc/emi62.c             |    2 --
 drivers/usb/serial/digi_acceleport.c |    2 --
 drivers/usb/serial/keyspan_pda.S     |    2 +-
 drivers/usb/serial/xircom_pgs.S      |    2 +-
 drivers/usb/storage/datafab.c        |    2 --
 drivers/usb/storage/debug.c          |    2 --
 drivers/usb/storage/debug.h          |    2 --
 drivers/usb/storage/dpcm.c           |    2 --
 drivers/usb/storage/dpcm.h           |    2 --
 drivers/usb/storage/freecom.c        |    2 --
 drivers/usb/storage/freecom.h        |    2 --
 drivers/usb/storage/initializers.c   |    2 --
 drivers/usb/storage/initializers.h   |    2 --
 drivers/usb/storage/isd200.c         |    2 --
 drivers/usb/storage/jumpshot.c       |    2 --
 drivers/usb/storage/protocol.c       |    2 --
 drivers/usb/storage/protocol.h       |    2 --
 drivers/usb/storage/scsiglue.c       |    2 --
 drivers/usb/storage/scsiglue.h       |    2 --
 drivers/usb/storage/sddr09.c         |    1 -
 drivers/usb/storage/sddr09.h         |    2 --
 drivers/usb/storage/sddr55.c         |    2 --
 drivers/usb/storage/sddr55.h         |    2 --
 drivers/usb/storage/shuttle_usbat.c  |    2 --
 drivers/usb/storage/shuttle_usbat.h  |    2 --
 drivers/usb/storage/transport.c      |    2 --
 drivers/usb/storage/transport.h      |    2 --
 drivers/usb/storage/unusual_devs.h   |    2 --
 drivers/usb/storage/usb.c            |    2 --
 drivers/usb/storage/usb.h            |    2 --
 include/linux/usbdevice_fs.h         |    2 --
 35 files changed, 2 insertions(+), 67 deletions(-)

3d05f2cfaa74de1a635eec9ed3b36c0389633010 diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 83d9dc3..a681d9b 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -46,8 +46,6 @@
  * 2000-07-05: Ashley Montanaro <ashley@compsoc.man.ac.uk>
  *   Converted file reading routine to dump to buffer once
  *   per device, not per bus
- *
- * $Id: devices.c,v 1.5 2000/01/11 13:58:21 tom Exp $
  */
 
 #include <linux/fs.h>
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index de17738..13cfaf3 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -19,8 +19,6 @@
  *      along with this program; if not, write to the Free Software
  *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- *  $Id: devio.c,v 1.7 2000/02/01 17:28:48 fliegl Exp $
- *
  *  This file implements the usbfs/x/y files, where
  *  x is the bus number and y the device number.
  *
diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index d0677f5..20b15fc 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -1,8 +1,6 @@
 /*
  * RNDIS MSG parser
  *
- * Version:     $Id: rndis.c,v 1.19 2004/03/25 21:33:46 robert Exp $
- *
  * Authors:	Benedikt Spranger, Pengutronix
  *		Robert Schwebel, Pengutronix
  *
diff --git a/drivers/usb/gadget/rndis.h b/drivers/usb/gadget/rndis.h
index 397b149..b917b4f 100644
--- a/drivers/usb/gadget/rndis.h
+++ b/drivers/usb/gadget/rndis.h
@@ -1,8 +1,6 @@
 /*
  * RNDIS	Definitions for Remote NDIS
  *
- * Version:	$Id: rndis.h,v 1.15 2004/03/25 21:33:46 robert Exp $
- *
  * Authors:	Benedikt Spranger, Pengutronix
  *		Robert Schwebel, Pengutronix
  *
diff --git a/drivers/usb/misc/emi62.c b/drivers/usb/misc/emi62.c
index 1a2b79a..0b1727d 100644
--- a/drivers/usb/misc/emi62.c
+++ b/drivers/usb/misc/emi62.c
@@ -6,8 +6,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License, as published by
  * the Free Software Foundation, version 2.
- * 
- * $Id: emi62.c,v 1.15 2002/04/23 06:13:59 tapio Exp $
  */
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 04a56f3..d96302d 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -229,8 +229,6 @@
 *    in case a wake up is lost.
 *  - Following Documentation/DocBook/kernel-locking.pdf no spin locks
 *    are held when calling copy_to/from_user or printk.
-*    
-*  $Id: digi_acceleport.c,v 1.80.1.2 2000/11/02 05:45:08 root Exp $
 */
 
 #include <linux/kernel.h>
diff --git a/drivers/usb/serial/keyspan_pda.S b/drivers/usb/serial/keyspan_pda.S
index 418fe69..006154b 100644
--- a/drivers/usb/serial/keyspan_pda.S
+++ b/drivers/usb/serial/keyspan_pda.S
@@ -1,4 +1,4 @@
-/*  $Id: loop.s,v 1.23 2000/03/20 09:49:06 warner Exp $
+/*
  * 
  *  Firmware for the Keyspan PDA Serial Adapter, a USB serial port based on
  *  the EzUSB microcontroller.
diff --git a/drivers/usb/serial/xircom_pgs.S b/drivers/usb/serial/xircom_pgs.S
index 05d99dd..fa7ccaa 100644
--- a/drivers/usb/serial/xircom_pgs.S
+++ b/drivers/usb/serial/xircom_pgs.S
@@ -1,4 +1,4 @@
-/*  $Id: loop.s,v 1.23 2000/03/20 09:49:06 warner Exp $
+/*
  * 
  *  Firmware for the Keyspan PDA Serial Adapter, a USB serial port based on
  *  the EzUSB microcontroller.
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index 579e9f5..17f1ae2 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -1,7 +1,5 @@
 /* Driver for Datafab USB Compact Flash reader
  *
- * $Id: datafab.c,v 1.7 2002/02/25 00:40:13 mdharm Exp $
- *
  * datafab driver v0.1:
  *
  * First release
diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index 01e4306..a2b5526 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -1,8 +1,6 @@
 /* Driver for USB Mass Storage compliant devices
  * Debugging Functions Source Code File
  *
- * $Id: debug.c,v 1.9 2002/04/22 03:39:43 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999-2002 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/debug.h b/drivers/usb/storage/debug.h
index 77e244a..dbb985d 100644
--- a/drivers/usb/storage/debug.h
+++ b/drivers/usb/storage/debug.h
@@ -1,8 +1,6 @@
 /* Driver for USB Mass Storage compliant devices
  * Debugging Functions Header File
  *
- * $Id: debug.h,v 1.6 2001/01/12 23:51:04 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999-2002 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/dpcm.c b/drivers/usb/storage/dpcm.c
index 9a410b5..9399234 100644
--- a/drivers/usb/storage/dpcm.c
+++ b/drivers/usb/storage/dpcm.c
@@ -1,7 +1,5 @@
 /* Driver for Microtech DPCM-USB CompactFlash/SmartMedia reader
  *
- * $Id: dpcm.c,v 1.4 2001/06/11 02:54:25 mdharm Exp $
- *
  * DPCM driver v0.1:
  *
  * First release
diff --git a/drivers/usb/storage/dpcm.h b/drivers/usb/storage/dpcm.h
index 81b464c..e7b7b0f 100644
--- a/drivers/usb/storage/dpcm.h
+++ b/drivers/usb/storage/dpcm.h
@@ -1,7 +1,5 @@
 /* Driver for Microtech DPCM-USB CompactFlash/SmartMedia reader
  *
- * $Id: dpcm.h,v 1.2 2000/08/25 00:13:51 mdharm Exp $
- *
  * DPCM driver v0.1:
  *
  * First release
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index f5a4e8d..7a4d456 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -1,7 +1,5 @@
 /* Driver for Freecom USB/IDE adaptor
  *
- * $Id: freecom.c,v 1.22 2002/04/22 03:39:43 mdharm Exp $
- *
  * Freecom v0.1:
  *
  * First release
diff --git a/drivers/usb/storage/freecom.h b/drivers/usb/storage/freecom.h
index 1b012d6..20d0fe6 100644
--- a/drivers/usb/storage/freecom.h
+++ b/drivers/usb/storage/freecom.h
@@ -1,7 +1,5 @@
 /* Driver for Freecom USB/IDE adaptor
  *
- * $Id: freecom.h,v 1.4 2000/08/29 14:49:15 dlbrown Exp $
- *
  * Freecom v0.1:
  *
  * First release
diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
index 187dd1e..4995bb5 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -1,7 +1,5 @@
 /* Special Initializers for certain USB Mass Storage devices
  *
- * $Id: initializers.c,v 1.2 2000/09/06 22:35:57 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999, 2000 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/initializers.h b/drivers/usb/storage/initializers.h
index ad3ffd4..529327f 100644
--- a/drivers/usb/storage/initializers.h
+++ b/drivers/usb/storage/initializers.h
@@ -1,7 +1,5 @@
 /* Header file for Special Initializers for certain USB Mass Storage devices
  *
- * $Id: initializers.h,v 1.1 2000/08/29 23:07:02 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999, 2000 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 3addcd8..2520dfe 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1,7 +1,5 @@
 /* Transport & Protocol Driver for In-System Design, Inc. ISD200 ASIC
  *
- * $Id: isd200.c,v 1.16 2002/04/22 03:39:43 mdharm Exp $
- *
  * Current development and maintenance:
  *   (C) 2001-2002 Björn Stenberg (bjorn@haxx.se)
  *
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 61097cb..df67f13 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -1,7 +1,5 @@
 /* Driver for Lexar "Jumpshot" Compact Flash reader
  *
- * $Id: jumpshot.c,v 1.7 2002/02/25 00:40:13 mdharm Exp $
- *
  * jumpshot driver v0.1:
  *
  * First release
diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index b9b8ede..3b3357e 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -1,7 +1,5 @@
 /* Driver for USB Mass Storage compliant devices
  *
- * $Id: protocol.c,v 1.14 2002/04/22 03:39:43 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999-2002 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/protocol.h b/drivers/usb/storage/protocol.h
index 8737a36..487056f 100644
--- a/drivers/usb/storage/protocol.h
+++ b/drivers/usb/storage/protocol.h
@@ -1,8 +1,6 @@
 /* Driver for USB Mass Storage compliant devices
  * Protocol Functions Header File
  *
- * $Id: protocol.h,v 1.4 2001/02/13 07:10:03 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999, 2000 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 3fcde9f..e1f3539 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -1,8 +1,6 @@
 /* Driver for USB Mass Storage compliant devices
  * SCSI layer glue code
  *
- * $Id: scsiglue.c,v 1.26 2002/04/22 03:39:43 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999-2002 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/scsiglue.h b/drivers/usb/storage/scsiglue.h
index 737e4fa..ffa1cca 100644
--- a/drivers/usb/storage/scsiglue.h
+++ b/drivers/usb/storage/scsiglue.h
@@ -1,8 +1,6 @@
 /* Driver for USB Mass Storage compliant devices
  * SCSI Connecting Glue Header File
  *
- * $Id: scsiglue.h,v 1.4 2000/08/25 00:13:51 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999, 2000 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index 8972b17..c5a54b8 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -1,6 +1,5 @@
 /* Driver for SanDisk SDDR-09 SmartMedia reader
  *
- * $Id: sddr09.c,v 1.24 2002/04/22 03:39:43 mdharm Exp $
  *   (c) 2000, 2001 Robert Baruch (autophile@starband.net)
  *   (c) 2002 Andries Brouwer (aeb@cwi.nl)
  * Developed with the assistance of:
diff --git a/drivers/usb/storage/sddr09.h b/drivers/usb/storage/sddr09.h
index c03089a..e50033a 100644
--- a/drivers/usb/storage/sddr09.h
+++ b/drivers/usb/storage/sddr09.h
@@ -1,8 +1,6 @@
 /* Driver for SanDisk SDDR-09 SmartMedia reader
  * Header File
  *
- * $Id: sddr09.h,v 1.5 2000/08/25 00:13:51 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 2000 Robert Baruch (autophile@dol.net)
  *   (c) 2002 Andries Brouwer (aeb@cwi.nl)
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index 6d14327..0d8df75 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -1,7 +1,5 @@
 /* Driver for SanDisk SDDR-55 SmartMedia reader
  *
- * $Id:$
- *
  * SDDR55 driver v0.1:
  *
  * First release
diff --git a/drivers/usb/storage/sddr55.h b/drivers/usb/storage/sddr55.h
index d6bd32f..a815a04 100644
--- a/drivers/usb/storage/sddr55.h
+++ b/drivers/usb/storage/sddr55.h
@@ -1,8 +1,6 @@
 /* Driver for SanDisk SDDR-55 SmartMedia reader
  * Header File
  *
- * $Id:$
- *
  * Current development and maintenance by:
  *   (c) 2002 Simon Munton
  *
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index 570c125..ae6d648 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -1,7 +1,5 @@
 /* Driver for SCM Microsystems (a.k.a. Shuttle) USB-ATAPI cable
  *
- * $Id: shuttle_usbat.c,v 1.17 2002/04/22 03:39:43 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 2000, 2001 Robert Baruch (autophile@starband.net)
  *   (c) 2004, 2005 Daniel Drake <dsd@gentoo.org>
diff --git a/drivers/usb/storage/shuttle_usbat.h b/drivers/usb/storage/shuttle_usbat.h
index 3ddf143..d8bfc43 100644
--- a/drivers/usb/storage/shuttle_usbat.h
+++ b/drivers/usb/storage/shuttle_usbat.h
@@ -1,8 +1,6 @@
 /* Driver for SCM Microsystems USB-ATAPI cable
  * Header File
  *
- * $Id: shuttle_usbat.h,v 1.5 2000/09/17 14:44:52 groovyjava Exp $
- *
  * Current development and maintenance by:
  *   (c) 2000 Robert Baruch (autophile@dol.net)
  *   (c) 2004, 2005 Daniel Drake <dsd@gentoo.org>
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 6610d2d..913bc58 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1,7 +1,5 @@
 /* Driver for USB Mass Storage compliant devices
  *
- * $Id: transport.c,v 1.47 2002/04/22 03:39:43 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999-2002 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/transport.h b/drivers/usb/storage/transport.h
index ada7c2f..e70b881 100644
--- a/drivers/usb/storage/transport.h
+++ b/drivers/usb/storage/transport.h
@@ -1,8 +1,6 @@
 /* Driver for USB Mass Storage compliant devices
  * Transport Functions Header File
  *
- * $Id: transport.h,v 1.18 2002/04/21 02:57:59 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999, 2000 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1b09578..ed69007 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1,8 +1,6 @@
 /* Driver for USB Mass Storage compliant devices
  * Unusual Devices File
  *
- * $Id: unusual_devs.h,v 1.32 2002/02/25 02:41:24 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 2000-2002 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index e268aac..27a8e67 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -1,7 +1,5 @@
 /* Driver for USB Mass Storage compliant devices
  *
- * $Id: usb.c,v 1.75 2002/04/22 03:39:43 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999-2003 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 8d87503..45d491f 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -1,8 +1,6 @@
 /* Driver for USB Mass Storage compliant devices
  * Main Header File
  *
- * $Id: usb.h,v 1.21 2002/04/21 02:57:59 mdharm Exp $
- *
  * Current development and maintenance by:
  *   (c) 1999-2002 Matthew Dharm (mdharm-usb@one-eyed-alien.net)
  *
diff --git a/include/linux/usbdevice_fs.h b/include/linux/usbdevice_fs.h
index 3118ede..0044d9b 100644
--- a/include/linux/usbdevice_fs.h
+++ b/include/linux/usbdevice_fs.h
@@ -22,8 +22,6 @@
  *
  *  History:
  *   0.1  04.01.2000  Created
- *
- *  $Id: usbdevice_fs.h,v 1.1 2000/01/06 18:40:41 tom Exp $
  */
 
 /*****************************************************************************/

