Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbZASNK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbZASNK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761469AbZASNKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:10:37 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:38034 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761182AbZASNKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PRKMekFUwjWlPhLgFscvo4uMs8VlJ+ilWAlvdV4VLflfBU8Dp1OXAOxIseapHU2XvK
         q5wKxCLm9iy8hkT5MJjRlZPiR3Hn27FyB3H1EYT7H4jUTXqHPh3e9lmAjW5Mkw7DQkap
         bqyxiao0jtmLvoHmTBf4GQ6IhGTTy8HrHJem4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 14:03:43 +0100
Message-Id: <20090119130343.24745.96981.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/6] ide: checkpatch.pl fixes for ide-iops.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: checkpatch.pl fixes for ide-iops.c

Fix following checkpatch.pl warnings/errors:
- WARNING: space prohibited between function name and open parenthesis '('
- WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
- WARNING: line over 80 characters
- ERROR: trailing whitespace
- ERROR: space required before the open parenthesis '('

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -27,7 +27,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-void SELECT_DRIVE (ide_drive_t *drive)
+void SELECT_DRIVE(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
@@ -84,7 +84,7 @@ void ide_fix_driveid(u16 *id)
  * returned by the ATA_CMD_ID_ATA[PI] commands.
  */
 
-void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
+void ide_fixstring(u8 *s, const int bytecount, const int byteswap)
 {
 	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
 
@@ -107,7 +107,6 @@ void ide_fixstring (u8 *s, const int byt
 	while (p != end)
 		*p++ = '\0';
 }
-
 EXPORT_SYMBOL(ide_fixstring);
 
 /*
@@ -121,7 +120,8 @@ EXPORT_SYMBOL(ide_fixstring);
  * setting a timer to wake up at half second intervals thereafter,
  * until timeout is achieved, before timing out.
  */
-static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout, u8 *rstat)
+static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad,
+			   unsigned long timeout, u8 *rstat)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
@@ -179,7 +179,8 @@ static int __ide_wait_stat(ide_drive_t *
  * The caller should return the updated value of "startstop" in this case,
  * "startstop" is unchanged when the function returns 0.
  */
-int ide_wait_stat(ide_startstop_t *startstop, ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout)
+int ide_wait_stat(ide_startstop_t *startstop, ide_drive_t *drive, u8 good,
+		  u8 bad, unsigned long timeout)
 {
 	int err;
 	u8 stat;
@@ -199,7 +200,6 @@ int ide_wait_stat(ide_startstop_t *start
 
 	return err;
 }
-
 EXPORT_SYMBOL(ide_wait_stat);
 
 /**
@@ -220,7 +220,6 @@ int ide_in_drive_list(u16 *id, const str
 			return 1;
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ide_in_drive_list);
 
 /*
@@ -245,7 +244,7 @@ static const struct drive_list_entry ivb
  *  All hosts that use the 80c ribbon must use!
  *  The name is derived from upper byte of word 93 and the 80c ribbon.
  */
-u8 eighty_ninty_three (ide_drive_t *drive)
+u8 eighty_ninty_three(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u16 *id = drive->id;
@@ -470,9 +469,8 @@ void ide_set_handler (ide_drive_t *drive
 	__ide_set_handler(drive, handler, timeout, expiry);
 	spin_unlock_irqrestore(&hwif->lock, flags);
 }
-
 EXPORT_SYMBOL(ide_set_handler);
- 
+
 /**
  *	ide_execute_command	-	execute an IDE command
  *	@drive: IDE drive to issue the command against
@@ -482,7 +480,7 @@ EXPORT_SYMBOL(ide_set_handler);
  *	@expiry:  handler to run on timeout
  *
  *	Helper function to issue an IDE command. This handles the
- *	atomicity requirements, command timing and ensures that the 
+ *	atomicity requirements, command timing and ensures that the
  *	handler and IRQ setup do not race. All IDE command kick off
  *	should go via this function or do equivalent locking.
  */
@@ -528,28 +526,29 @@ static inline void ide_complete_drive_re
 }
 
 /* needed below */
-static ide_startstop_t do_reset1 (ide_drive_t *, int);
+static ide_startstop_t do_reset1(ide_drive_t *, int);
 
 /*
- * atapi_reset_pollfunc() gets invoked to poll the interface for completion every 50ms
- * during an atapi drive reset operation. If the drive has not yet responded,
- * and we have not yet hit our maximum waiting time, then the timer is restarted
- * for another 50ms.
+ * atapi_reset_pollfunc() gets invoked to poll the interface for completion
+ * every 50ms during an atapi drive reset operation.  If the drive has not yet
+ * responded, and we have not yet hit our maximum waiting time, then the timer
+ * is restarted for another 50ms.
  */
-static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
+static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 stat;
 
 	SELECT_DRIVE(drive);
-	udelay (10);
+	udelay(10);
 	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, 0, ATA_BUSY))
 		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
 	else {
 		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
+			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20,
+					NULL);
 			/* continue polling */
 			return ide_started;
 		}
@@ -591,7 +590,7 @@ static void ide_reset_report_error(ide_h
  * and we have not yet hit our maximum waiting time, then the timer is restarted
  * for another 50ms.
  */
-static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
+static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
@@ -703,7 +702,7 @@ static void pre_reset(ide_drive_t *drive
  * (up to 30 seconds worstcase).  So, instead of busy-waiting here for it,
  * we set a timer to poll at 50ms intervals.
  */
-static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
+static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -723,7 +722,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	if (drive->media != ide_disk && !do_not_try_atapi) {
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
-		udelay (20);
+		udelay(20);
 		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 		ndelay(400);
 		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
@@ -807,11 +806,10 @@ static ide_startstop_t do_reset1 (ide_dr
  * ide_do_reset() is the entry point to the drive/interface reset code.
  */
 
-ide_startstop_t ide_do_reset (ide_drive_t *drive)
+ide_startstop_t ide_do_reset(ide_drive_t *drive)
 {
 	return do_reset1(drive, 0);
 }
-
 EXPORT_SYMBOL(ide_do_reset);
 
 /*
@@ -822,7 +820,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 {
 	u8 stat = 0;
 
-	while(timeout--) {
+	while (timeout--) {
 		/*
 		 * Turn this into a schedule() sleep once I'm sure
 		 * about locking issues (2.5 work ?).
