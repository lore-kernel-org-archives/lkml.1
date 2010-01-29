Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765Ab0A2UWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0A2UWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088Ab0A2UWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:22:51 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:52139 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab0A2UWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:22:50 -0500
Message-ID: <4B634396.5000809@msgid.tls.msk.ru>
Date: Fri, 29 Jan 2010 23:22:46 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31 oops
References: <20100128194940.GJ14574@charite.de>
In-Reply-To: <20100128194940.GJ14574@charite.de>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Hildebrandt wrote:
> This is on a dovecot mailbox server which extensively uses inotify...

Ralf, this is quite old bug, fixed by commit 9f0d793b52eb2266359661369ef6303838904855.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=9f0d793b52eb2266359661369ef6303838904855

It should be in 2.6.31.y somewhere too, and fixed in 2.6.32.

I hit it with dovecot too.  It should be in redhat bugzilla too.

/mjt

> [61834.698645] WARNING: at
> /tmp/buildd/linux-2.6-2.6.31/debian/build/source_i386_none/fs/notify/inotify/inotify_fsnotify.c:129
> idr_callback+0x39/0x6c()
> [61834.699107] Hardware name: VMware Virtual Platform
> [61834.699337] inotify closing but id=0 for entry=c646a514 in group=c99498c0 still in idr.  Probably leaking memory
> [61834.699689] Modules linked in: acpiphp ext4 jbd2 crc16 parport_pc parport evdev serio_raw psmouse snd_pcsp snd_pcm snd_timer snd
> soundcore snd_page_alloc ac container processor button vmci i2c_piix4 shpchp pci_hotplug i2c_core ext3 jbd mbcache dm_mod ide_cd_mod cdrom
> sd_mod crc_t10dif ata_generic libata ide_pci_generic mptspi mptscsih mptbase scsi_transport_spi pcnet32 floppy mii scsi_mod piix ide_core
> intel_agp agpgart thermal fan thermal_sys [last unloaded: scsi_wait_scan]
> [61834.701741] Pid: 5168, comm: imap Not tainted 2.6.31-1-686-bigmem #1
...
