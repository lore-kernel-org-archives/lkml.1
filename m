Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbYBWOHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbYBWOHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYBWOFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:05:36 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:17790 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbYBWOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:05:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=BfVO7+Phkthy0rucbpS8ZWTwQYk4hLfmJwdbIJdwFQgtUoyMZ4pXVvSBrg+UFAkR6OtTEd4yQIxgOYKCNzKZCEgw+rqzLMYv6T0AK05+lopYV6D6jsX7ViJcP+VzLQCI8wGsade+R1sYlwIHHjVYL9Ho6bNFH+Ao4BHUZxO91oY=
Date: Sat, 23 Feb 2008 15:05:25 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 05/10] IDE: Coding Style fixes to drivers/ide/ide-proc.c
Message-ID: <20080223150525.517630cf@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lot of errors and warnings removed.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/ide-proc.c |  175 +++++++++++++++++++++++------------------------
 1 files changed, 86 insertions(+), 89 deletions(-)

diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 7c4af31..a1833d6 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -47,28 +47,28 @@ static int proc_ide_read_imodel
 	const char	*name;
 
 	switch (hwif->chipset) {
-		case ide_generic:	name = "generic";	break;
-		case ide_pci:		name = "pci";		break;
-		case ide_cmd640:	name = "cmd640";	break;
-		case ide_dtc2278:	name = "dtc2278";	break;
-		case ide_ali14xx:	name = "ali14xx";	break;
-		case ide_qd65xx:	name = "qd65xx";	break;
-		case ide_umc8672:	name = "umc8672";	break;
-		case ide_ht6560b:	name = "ht6560b";	break;
-		case ide_rz1000:	name = "rz1000";	break;
-		case ide_trm290:	name = "trm290";	break;
-		case ide_cmd646:	name = "cmd646";	break;
-		case ide_cy82c693:	name = "cy82c693";	break;
-		case ide_4drives:	name = "4drives";	break;
-		case ide_pmac:		name = "mac-io";	break;
-		case ide_au1xxx:	name = "au1xxx";	break;
-		case ide_palm3710:      name = "palm3710";      break;
-		case ide_etrax100:	name = "etrax100";	break;
-		case ide_acorn:		name = "acorn";		break;
-		default:		name = "(unknown)";	break;
+	case ide_generic:	name = "generic";	break;
+	case ide_pci:		name = "pci";		break;
+	case ide_cmd640:	name = "cmd640";	break;
+	case ide_dtc2278:	name = "dtc2278";	break;
+	case ide_ali14xx:	name = "ali14xx";	break;
+	case ide_qd65xx:	name = "qd65xx";	break;
+	case ide_umc8672:	name = "umc8672";	break;
+	case ide_ht6560b:	name = "ht6560b";	break;
+	case ide_rz1000:	name = "rz1000";	break;
+	case ide_trm290:	name = "trm290";	break;
+	case ide_cmd646:	name = "cmd646";	break;
+	case ide_cy82c693:	name = "cy82c693";	break;
+	case ide_4drives:	name = "4drives";	break;
+	case ide_pmac:		name = "mac-io";	break;
+	case ide_au1xxx:	name = "au1xxx";	break;
+	case ide_palm3710:      name = "palm3710";      break;
+	case ide_etrax100:	name = "etrax100";	break;
+	case ide_acorn:		name = "acorn";		break;
+	default:		name = "(unknown)";	break;
 	}
 	len = sprintf(page, "%s\n", name);
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_ide_read_mate
@@ -81,7 +81,7 @@ static int proc_ide_read_mate
 		len = sprintf(page, "%s\n", hwif->mate->name);
 	else
 		len = sprintf(page, "(none)\n");
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_ide_read_channel
@@ -93,7 +93,7 @@ static int proc_ide_read_channel
 	page[0] = hwif->channel ? '1' : '0';
 	page[1] = '\n';
 	len = 2;
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_ide_read_identify
@@ -120,10 +120,10 @@ static int proc_ide_read_identify
 			len = out - page;
 		}
 	}
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
-/**
+/*
  *	__ide_add_setting	-	add an ide setting option
  *	@drive: drive to use
  *	@name: setting name
@@ -185,10 +185,9 @@ int ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type,
 {
 	return __ide_add_setting(drive, name, rw, data_type, min, max, mul_factor, div_factor, data, set, 1);
 }
-
 EXPORT_SYMBOL(ide_add_setting);
 
-/**
+/*
  *	__ide_remove_setting	-	remove an ide setting option
  *	@drive: drive to use
  *	@name: setting name
@@ -197,7 +196,7 @@ EXPORT_SYMBOL(ide_add_setting);
  *	The caller must hold the setting semaphore.
  */
 
-static void __ide_remove_setting (ide_drive_t *drive, char *name)
+static void __ide_remove_setting(ide_drive_t *drive, char *name)
 {
 	ide_settings_t **p, *setting;
 
@@ -205,7 +204,8 @@ static void __ide_remove_setting (ide_drive_t *drive, char *name)
 
 	while ((*p) && strcmp((*p)->name, name))
 		p = &((*p)->next);
-	if ((setting = (*p)) == NULL)
+	setting = (*p);
+	if (setting == NULL)
 		return;
 
 	(*p) = setting->next;
@@ -214,7 +214,7 @@ static void __ide_remove_setting (ide_drive_t *drive, char *name)
 	kfree(setting);
 }
 
-/**
+/*
  *	auto_remove_settings	-	remove driver specific settings
  *	@drive: drive
  *
@@ -223,7 +223,7 @@ static void __ide_remove_setting (ide_drive_t *drive, char *name)
  *	caller must hold ide_setting_mtx.
  */
 
-static void auto_remove_settings (ide_drive_t *drive)
+static void auto_remove_settings(ide_drive_t *drive)
 {
 	ide_settings_t *setting;
 repeat:
@@ -237,7 +237,7 @@ repeat:
 	}
 }
 
-/**
+/*
  *	ide_find_setting_by_name	-	find a drive specific setting
  *	@drive: drive to scan
  *	@name: setting name
@@ -259,7 +259,7 @@ static ide_settings_t *ide_find_setting_by_name(ide_drive_t *drive, char *name)
 	return setting;
 }
 
-/**
+/*
  *	ide_read_setting	-	read an IDE setting
  *	@drive: drive to read from
  *	@setting: drive setting
@@ -279,23 +279,23 @@ static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
 
 	if ((setting->rw & SETTING_READ)) {
 		spin_lock_irqsave(&ide_lock, flags);
-		switch(setting->data_type) {
-			case TYPE_BYTE:
-				val = *((u8 *) setting->data);
-				break;
-			case TYPE_SHORT:
-				val = *((u16 *) setting->data);
-				break;
-			case TYPE_INT:
-				val = *((u32 *) setting->data);
-				break;
+		switch (setting->data_type) {
+		case TYPE_BYTE:
+			val = *((u8 *) setting->data);
+			break;
+		case TYPE_SHORT:
+			val = *((u16 *) setting->data);
+			break;
+		case TYPE_INT:
+			val = *((u32 *) setting->data);
+			break;
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
 	}
 	return val;
 }
 
-/**
+/*
  *	ide_write_setting	-	read an IDE setting
  *	@drive: drive to read from
  *	@setting: drive setting
@@ -326,15 +326,15 @@ static int ide_write_setting(ide_drive_t *drive, ide_settings_t *setting, int va
 	if (ide_spin_wait_hwgroup(drive))
 		return -EBUSY;
 	switch (setting->data_type) {
-		case TYPE_BYTE:
-			*((u8 *) setting->data) = val;
-			break;
-		case TYPE_SHORT:
-			*((u16 *) setting->data) = val;
-			break;
-		case TYPE_INT:
-			*((u32 *) setting->data) = val;
-			break;
+	case TYPE_BYTE:
+		*((u8 *) setting->data) = val;
+		break;
+	case TYPE_SHORT:
+		*((u16 *) setting->data) = val;
+		break;
+	case TYPE_INT:
+		*((u32 *) setting->data) = val;
+		break;
 	}
 	spin_unlock_irq(&ide_lock);
 	return 0;
@@ -364,7 +364,7 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
 	return err;
 }
 
-/**
+/*
  *	ide_add_generic_settings	-	generic ide settings
  *	@drive: drive being configured
  *
@@ -390,7 +390,7 @@ void ide_add_generic_settings (ide_drive_t *drive)
 
 static void proc_ide_settings_warn(void)
 {
-	static int warned = 0;
+	static int warned;
 
 	if (warned)
 		return;
@@ -413,11 +413,12 @@ static int proc_ide_read_settings
 	mutex_lock(&ide_setting_mtx);
 	out += sprintf(out, "name\t\t\tvalue\t\tmin\t\tmax\t\tmode\n");
 	out += sprintf(out, "----\t\t\t-----\t\t---\t\t---\t\t----\n");
-	while(setting) {
+	while (setting) {
 		mul_factor = setting->mul_factor;
 		div_factor = setting->div_factor;
 		out += sprintf(out, "%-24s", setting->name);
-		if ((rc = ide_read_setting(drive, setting)) >= 0)
+		rc = ide_read_setting(drive, setting);
+		if (rc >= 0)
 			out += sprintf(out, "%-16d", rc * mul_factor / div_factor);
 		else
 			out += sprintf(out, "%-16s", "write-only");
@@ -431,7 +432,7 @@ static int proc_ide_read_settings
 	}
 	len = out - page;
 	mutex_unlock(&ide_setting_mtx);
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 #define MAX_LEN	30
@@ -512,8 +513,7 @@ static int proc_ide_write_settings(struct file *file, const char __user *buffer,
 
 			mutex_lock(&ide_setting_mtx);
 			setting = ide_find_setting_by_name(drive, name);
-			if (!setting)
-			{
+			if (!setting) {
 				mutex_unlock(&ide_setting_mtx);
 				goto parse_error;
 			}
@@ -533,8 +533,8 @@ parse_error:
 int proc_ide_read_capacity
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
-	int len = sprintf(page,"%llu\n", (long long)0x7fffffff);
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	int len = sprintf(page, "%llu\n", (long long)0x7fffffff);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 EXPORT_SYMBOL_GPL(proc_ide_read_capacity);
@@ -546,13 +546,13 @@ int proc_ide_read_geometry
 	char		*out = page;
 	int		len;
 
-	out += sprintf(out,"physical     %d/%d/%d\n",
+	out += sprintf(out, "physical     %d/%d/%d\n",
 			drive->cyl, drive->head, drive->sect);
-	out += sprintf(out,"logical      %d/%d/%d\n",
+	out += sprintf(out, "logical      %d/%d/%d\n",
 			drive->bios_cyl, drive->bios_head, drive->bios_sect);
 
 	len = out - page;
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 EXPORT_SYMBOL(proc_ide_read_geometry);
@@ -566,7 +566,7 @@ static int proc_ide_read_dmodel
 
 	len = sprintf(page, "%.40s\n",
 		(id && id->model[0]) ? (char *)id->model : "(none)");
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int proc_ide_read_driver
@@ -583,7 +583,7 @@ static int proc_ide_read_driver
 				dev->driver->name, ide_drv->version);
 	} else
 		len = sprintf(page, "ide-default version 0.9.newide\n");
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
@@ -639,30 +639,30 @@ static int proc_ide_read_media
 	int		len;
 
 	switch (drive->media) {
-		case ide_disk:	media = "disk\n";
-				break;
-		case ide_cdrom:	media = "cdrom\n";
-				break;
-		case ide_tape:	media = "tape\n";
-				break;
-		case ide_floppy:media = "floppy\n";
-				break;
-		case ide_optical:media = "optical\n";
-				break;
-		default:	media = "UNKNOWN\n";
+	case ide_disk:	media = "disk\n";
+			break;
+	case ide_cdrom:	media = "cdrom\n";
+			break;
+	case ide_tape:	media = "tape\n";
+			break;
+	case ide_floppy:media = "floppy\n";
+			break;
+	case ide_optical:media = "optical\n";
+			break;
+	default:	media = "UNKNOWN\n";
 				break;
 	}
-	strcpy(page,media);
+	strcpy(page, media);
 	len = strlen(media);
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static ide_proc_entry_t generic_drive_entries[] = {
-	{ "driver",	S_IFREG|S_IRUGO,	proc_ide_read_driver,	proc_ide_write_driver },
-	{ "identify",	S_IFREG|S_IRUSR,	proc_ide_read_identify,	NULL },
-	{ "media",	S_IFREG|S_IRUGO,	proc_ide_read_media,	NULL },
-	{ "model",	S_IFREG|S_IRUGO,	proc_ide_read_dmodel,	NULL },
-	{ "settings",	S_IFREG|S_IRUSR|S_IWUSR,proc_ide_read_settings,	proc_ide_write_settings },
+	{ "driver", S_IFREG|S_IRUGO, proc_ide_read_driver, proc_ide_write_driver },
+	{ "identify", S_IFREG|S_IRUSR, proc_ide_read_identify, NULL },
+	{ "media", S_IFREG|S_IRUGO, proc_ide_read_media, NULL },
+	{ "model", S_IFREG|S_IRUGO, proc_ide_read_dmodel, NULL },
+	{ "settings", S_IFREG|S_IRUSR|S_IWUSR, proc_ide_read_settings,	proc_ide_write_settings },
 	{ NULL,	0, NULL, NULL }
 };
 
@@ -696,10 +696,9 @@ void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver)
 {
 	ide_add_proc_entries(drive->proc, driver->proc, drive);
 }
-
 EXPORT_SYMBOL(ide_proc_register_driver);
 
-/**
+/*
  *	ide_proc_unregister_driver	-	remove driver specific data
  *	@drive: drive
  *	@driver: driver
@@ -734,7 +733,6 @@ void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
 	spin_unlock_irqrestore(&ide_lock, flags);
 	mutex_unlock(&ide_setting_mtx);
 }
-
 EXPORT_SYMBOL(ide_proc_unregister_driver);
 
 void ide_proc_port_register_devices(ide_hwif_t *hwif)
@@ -755,7 +753,7 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 		drive->proc = proc_mkdir(drive->name, parent);
 		if (drive->proc)
 			ide_add_proc_entries(drive->proc, generic_drive_entries, drive);
-		sprintf(name,"ide%d/%s", (drive->name[2]-'a')/2, drive->name);
+		sprintf(name, "ide%d/%s", (drive->name[2]-'a')/2, drive->name);
 		ent = proc_symlink(drive->name, proc_ide_root, name);
 		if (!ent) return;
 	}
@@ -806,7 +804,6 @@ void ide_pci_create_host_proc(const char *name, get_info_t *get_info)
 {
 	create_proc_info_entry(name, 0, proc_ide_root, get_info);
 }
-
 EXPORT_SYMBOL_GPL(ide_pci_create_host_proc);
 #endif
 
-- 
1.5.4.2.316.gf7a7

