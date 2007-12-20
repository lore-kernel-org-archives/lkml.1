Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbXLTBil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbXLTBil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbXLTBes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbXLTBeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tA3G/J42tKuM50AAhIfPTZ+AqdBuNUyyf/CNAd3rGdTxyn+G5DweE0qstv2JqI4mUld8gKBvH5QK17fySw2u4/mzb5b/MQMSdAYpNdlsc++FXG68Wkbj9LUUpDusIhOO12oZMxNgtLroTCV/sU/XtIDGeKqiGT/4kEXj9a8oxqo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 14/63] ide-cd: fix trailing whitespaces in changelog
Date: Thu, 20 Dec 2007 02:02:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200202.49548.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -129,16 +129,15 @@
  * 3.14  May 29, 1996 -- Add work-around for Vertos 600.
  *                        (From Hennus Bergman <hennus@sky.ow.nl>.)
  * 3.15  July 2, 1996 -- Added support for Sanyo 3 CD changers
- *                        from Ben Galliart <bgallia@luc.edu> with 
- *                        special help from Jeff Lightfoot 
+ *                        from Ben Galliart <bgallia@luc.edu> with
+ *                        special help from Jeff Lightfoot
  *                        <jeffml@pobox.com>
  * 3.15a July 9, 1996 -- Improved Sanyo 3 CD changer identification
  * 3.16  Jul 28, 1996 -- Fix from Gadi to reduce kernel stack usage for ioctl.
  * 3.17  Sep 17, 1996 -- Tweak audio reads for some drives.
  *                       Start changing CDROMLOADFROMSLOT to CDROM_SELECT_DISC.
  * 3.18  Oct 31, 1996 -- Added module and DMA support.
- *                       
- *                       
+ *
  * 4.00  Nov 5, 1996   -- New ide-cd maintainer,
  *                                 Erik B. Andersen <andersee@debian.org>
  *                     -- Newer Creative drives don't always set the error
@@ -153,8 +152,8 @@
  *                     -- Add some probes of drive capability during setup.
  *
  * 4.01  Nov 11, 1996  -- Split into ide-cd.c and ide-cd.h
- *                     -- Removed CDROMMECHANISMSTATUS and CDROMSLOTTABLE 
- *                          ioctls in favor of a generalized approach 
+ *                     -- Removed CDROMMECHANISMSTATUS and CDROMSLOTTABLE
+ *                          ioctls in favor of a generalized approach
  *                          using the generic cdrom driver.
  *                     -- Fully integrated with the 2.1.X kernel.
  *                     -- Other stuff that I forgot (lots of changes)
@@ -163,7 +162,7 @@
  *                          to fix the drive door locking problems.
  *
  * 4.03  Dec 04, 1996  -- Added DSC overlap support.
- * 4.04  Dec 29, 1996  -- Added CDROMREADRAW ioclt based on patch 
+ * 4.04  Dec 29, 1996  -- Added CDROMREADRAW ioclt based on patch
  *                          by Ales Makarov (xmakarov@sun.felk.cvut.cz)
  *
  * 4.05  Nov 20, 1997  -- Modified to print more drive info on init
@@ -186,7 +185,7 @@
  *                     -- Cleaned up the global namespace a bit by making more
  *                         functions static that should already have been.
  * 4.11  Mar 12, 1998  -- Added support for the CDROM_SELECT_SPEED ioctl
- *                         based on a patch for 2.0.33 by Jelle Foks 
+ *                         based on a patch for 2.0.33 by Jelle Foks
  *                         <jelle@scintilla.utwente.nl>, a patch for 2.0.33
  *                         by Toni Giorgino <toni@pcape2.pi.infn.it>, the SCSI
  *                         version, and my own efforts.  -erik
@@ -194,8 +193,8 @@
  *                         inform me of where "Illegal mode for this track"
  *                         was never returned due to a comparison on data
  *                         types of limited range.
- * 4.12  Mar 29, 1998  -- Fixed bug in CDROM_SELECT_SPEED so write speed is 
- *                         now set ionly for CD-R and CD-RW drives.  I had 
+ * 4.12  Mar 29, 1998  -- Fixed bug in CDROM_SELECT_SPEED so write speed is
+ *                         now set ionly for CD-R and CD-RW drives.  I had
  *                         removed this support because it produced errors.
  *                         It produced errors _only_ for non-writers. duh.
  * 4.13  May 05, 1998  -- Suppress useless "in progress of becoming ready"
@@ -206,7 +205,7 @@
  *                         since the .pdf version doesn't seem to work...
  *                     -- Updated the TODO list to something more current.
  *
- * 4.15  Aug 25, 1998  -- Updated ide-cd.h to respect mechine endianess, 
+ * 4.15  Aug 25, 1998  -- Updated ide-cd.h to respect mechine endianess,
  *                         patch thanks to "Eddie C. Dost" <ecd@skynet.be>
  *
  * 4.50  Oct 19, 1998  -- New maintainers!
@@ -270,7 +269,7 @@
  *			- Mode sense and mode select moved to the
  *			  Uniform layer.
  *			- Fixed a problem with WPI CDS-32X drive - it
- *			  failed the capabilities 
+ *			  failed the capabilities
  *
  * 4.57  Apr 7, 2000	- Fixed sense reporting.
  *			- Fixed possible oops in ide_cdrom_get_last_session()
