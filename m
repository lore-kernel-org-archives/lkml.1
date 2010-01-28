Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641Ab0A1UAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0A1UAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503Ab0A1UAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:00:07 -0500
Received: from mail-ausfall.charite.de ([193.175.72.31]:60016 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab0A1UAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:00:06 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 15:00:06 EST
Date: Thu, 28 Jan 2010 20:49:41 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.31 oops
Message-ID: <20100128194940.GJ14574@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on a dovecot mailbox server which extensively uses inotify...

[61834.696727] ------------[ cut here ]------------
[61834.698645] WARNING: at
/tmp/buildd/linux-2.6-2.6.31/debian/build/source_i386_none/fs/notify/inotify/inotify_fsnotify.c:129
idr_callback+0x39/0x6c()
[61834.699107] Hardware name: VMware Virtual Platform
[61834.699337] inotify closing but id=0 for entry=c646a514 in group=c99498c0 still in idr.  Probably leaking memory
[61834.699689] Modules linked in: acpiphp ext4 jbd2 crc16 parport_pc parport evdev serio_raw psmouse snd_pcsp snd_pcm snd_timer snd
soundcore snd_page_alloc ac container processor button vmci i2c_piix4 shpchp pci_hotplug i2c_core ext3 jbd mbcache dm_mod ide_cd_mod cdrom
sd_mod crc_t10dif ata_generic libata ide_pci_generic mptspi mptscsih mptbase scsi_transport_spi pcnet32 floppy mii scsi_mod piix ide_core
intel_agp agpgart thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[61834.701741] Pid: 5168, comm: imap Not tainted 2.6.31-1-686-bigmem #1
[61834.701962] Call Trace:
[61834.702379]  [<c103fc1a>] ? warn_slowpath_common+0x6c/0xaa
[61834.702568]  [<c103fcba>] ? warn_slowpath_fmt+0x34/0x4c
[61834.702731]  [<c10fe06c>] ? idr_callback+0x39/0x6c
[61834.703000]  [<c116a850>] ? idr_for_each+0x68/0xb2
[61834.703161]  [<c10fe033>] ? idr_callback+0x0/0x6c
[61834.703328]  [<c10fe012>] ? inotify_free_group_priv+0x20/0x41
[61834.703497]  [<c10fc1f9>] ? fsnotify_final_destroy_group+0x26/0x40
[61834.703669]  [<c10fe276>] ? inotify_release+0x24/0x42
[61834.703833]  [<c10d3480>] ? __fput+0xe1/0x19b
[61834.703984]  [<c10cffda>] ? filp_close+0x5c/0x74
[61834.704202]  [<c10d005a>] ? sys_close+0x68/0xad
[61834.704367]  [<c10087fb>] ? sysenter_do_call+0x12/0x28
[61834.704629] ---[ end trace 8f9d51f75f799189 ]---
[61834.704854] entry->group=(null) inode=(null) wd=1024
[61834.769078] ------------[ cut here ]------------

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
