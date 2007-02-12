Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbXBLGML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbXBLGML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933024AbXBLGMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:12:10 -0500
Received: from paragon.brong.net ([66.232.154.163]:46401 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbXBLGMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:12:09 -0500
Date: Mon, 12 Feb 2007 17:12:00 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.40
Message-ID: <20070212061200.GA24889@brong.net>
References: <20070210164113.GG12958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210164113.GG12958@stusta.de>
Organization: brong.net
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 05:41:13PM +0100, Adrian Bunk wrote:
> New drivers since 2.6.16.39:
> - Areca ARC11X0/ARC12X0 SATA-RAID support
> - AMD Athlon64/FX and Opteron temperature sensor
> 
> 
> Location:
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/
> 
> git tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git
> 
> 
> Changes since 2.6.16.39:
> 
> Adrian Bunk (2):
>       Linux 2.6.16.40-rc1
>       Linux 2.6.16.40
> 
> Andrew Morton (1):
>       [SCSI] areca sysfs fix
> 
> Bartlomiej Zolnierkiewicz (1):
>       ia64: add pci_get_legacy_ide_irq()
> 
> Erich Chen (1):
>       [SCSI] arcmsr: initial driver, version 1.20.00.13
> 
> James Bottomley (1):
>       [SCSI] arcmsr: fix up sysfs values
> 
> Jeff Garzik (1):
>       [libata] use kmap_atomic(KM_IRQ0) in SCSI simulator
> 
> Neil Brown (1):
>       Make 'repair' actually work for raid1.
> 
> Rudolf Marek (4):
>       hwmon: New driver k8temp
>       k8temp: Add documentation
>       k8temp: Documentation update
>       hwmon: Update Rudolf Marek's e-mail address
> 
> Vladimir Saveliev (1):
>       reiserfs: avoid tail packing if an inode was ever mmapped
> 
> 
>  Documentation/hwmon/k8temp          |   55 +
>  Documentation/scsi/ChangeLog.arcmsr |   56 +
>  Documentation/scsi/arcmsr_spec.txt  |  574 ++++++++++
>  MAINTAINERS                         |    6 
>  Makefile                            |    2 
>  drivers/hwmon/Kconfig               |   12 
>  drivers/hwmon/Makefile              |    1 
>  drivers/hwmon/hwmon-vid.c           |    4 
>  drivers/hwmon/k8temp.c              |  292 +++++
>  drivers/hwmon/w83792d.c             |    2 
>  drivers/i2c/busses/i2c-ali1563.c    |    2 
>  drivers/md/md.c                     |    2 
>  drivers/md/raid1.c                  |    5 
>  drivers/scsi/Kconfig                |   14 
>  drivers/scsi/Makefile               |    1 
>  drivers/scsi/arcmsr/Makefile        |    6 
>  drivers/scsi/arcmsr/arcmsr.h        |  472 ++++++++
>  drivers/scsi/arcmsr/arcmsr_attr.c   |  381 +++++++
>  drivers/scsi/arcmsr/arcmsr_hba.c    | 1496 ++++++++++++++++++++++++++++
>  drivers/scsi/libata-scsi.c          |    4 
>  fs/reiserfs/file.c                  |   20 
>  fs/reiserfs/inode.c                 |    2 
>  include/asm-ia64/pci.h              |    6 
>  include/linux/pci_ids.h             |   18 
>  include/linux/reiserfs_fs_i.h       |    2 
>  25 files changed, 3426 insertions(+), 9 deletions(-)
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
