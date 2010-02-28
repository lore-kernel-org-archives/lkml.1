Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030946Ab0B1AIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 19:08:48 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:53996 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030928Ab0B1AIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 19:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding:x-mailer
         :mime-version:subject:date:cc;
        b=HCZQjnBZyMcj2QRXv7NxWedXya7b4tnloEwlZNyTjKR+zGIXdJcYE3fd4tKtrze5D5
         HiiqQCwJ7oPE3+9FT7j2M9Kf2L+1dEfduz8Iyn7ZwDHOV1eCL8KxXH6NL15Kci1maG0R
         Q2x7IkCeZ+Wy0TzGTbJwD8zz3IR8uH0WoS2TM=
Message-Id: <E153A4E2-8955-4FE8-B9CE-0916A676E2FB@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ruben Puettmann <ruben@puettmann.net>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: VMware PVSCSI Warning 2.6.33
Date: Sat, 27 Feb 2010 16:08:27 -0800
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       pv-drivers <pv-drivers@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding pv-drivers to CC.

-- Dmitry


On Feb 27, 2010, at 2:30 PM, Ruben Puettmann <ruben@puettmann.net>  
wrote:

>
>       hy,
>
> I'm testing the new VMware PVSCSI driver. I have build 2.6.33,  
> config is
> attached. I got this warning during boot:
>
>
> Loading iSCSI transport class v2.0-870.
> VMware PVSCSI driver - version 1.0.1.0-k
> vmw_pvscsi 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> vmw_pvscsi: using 64bit dma
> vmw_pvscsi 0000:03:00.0: setting latency timer to 64
> vmw_pvscsi 0000:03:00.0: irq 56 for MSI/MSI-X
> vmw_pvscsi: using MSI-X
> scsi0 : VMware PVSCSI storage adapter rev 1, req/cmp/msg rings:  
> 8/8/0 pages, cmd_per_lun=64
> vmw_pvscsi 0000:03:00.0: VMware PVSCSI rev 1 host #0
> scsi 0:0:0:0: Direct-Access     VMware   Virtual disk     1.0  PQ: 0  
> ANSI: 2
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x5f/0x70()
> Hardware name: VMware Virtual Platform
> sysfs: cannot create duplicate filename '/bus/scsi/drivers/sd/0:0:0:0'
> Modules linked in:
> Pid: 1032, comm: scsi_scan_0 Not tainted 2.6.33 #1
> Call Trace:
> [<c1022af3>] ? warn_slowpath_common+0x5d/0x70
> [<c1022b39>] ? warn_slowpath_fmt+0x26/0x2a
> [<c10b40e3>] ? sysfs_add_one+0x5f/0x70
> [<c10b47ed>] ? sysfs_do_create_link+0x97/0xee
> [<c10b4854>] ? sysfs_create_link+0x7/0xb
> [<c116cc92>] ? driver_sysfs_add+0x18/0x4a
> [<c116ce8d>] ? device_bind_driver+0x9/0x1b
> [<c116cec0>] ? device_attach+0x21/0x54
> [<c116c4c0>] ? bus_probe_device+0x15/0x29
> [<c116b5ae>] ? device_add+0x2d2/0x406
> [<c1181c39>] ? spi_device_match+0xa/0x4f
> [<c116e9bd>] ? attribute_container_device_trigger+0x7e/0x85
> [<c117fbca>] ? scsi_sysfs_add_sdev+0xa0/0x1ba
> [<c1177299>] ? __scsi_iterate_devices+0x47/0x5a
> [<c117ec00>] ? do_scan_async+0x6e/0xf8
> [<c117eb92>] ? do_scan_async+0x0/0xf8
> [<c1031daf>] ? kthread+0x5f/0x64
> [<c1031d50>] ? kthread+0x0/0x64
> [<c1002af6>] ? kernel_thread_helper+0x6/0x10
> ---[ end trace e72efb15e7d230f5 ]---
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x5f/0x70()
> Hardware name: VMware Virtual Platform
> sysfs: cannot create duplicate filename '/devices/ 
> pci0000:00/0000:00:15.0/0000:03:00.0/host0/target0:0:0/0:0:0:0/driver'
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W  2.6.33 #1
> Call Trace:
> [<c1022af3>] ? warn_slowpath_common+0x5d/0x70
> [<c1022b39>] ? warn_slowpath_fmt+0x26/0x2a
> [<c10b40e3>] ? sysfs_add_one+0x5f/0x70
> [<c10b47ed>] ? sysfs_do_create_link+0x97/0xee
> [<c10b4854>] ? sysfs_create_link+0x7/0xb
> [<c116ccaa>] ? driver_sysfs_add+0x30/0x4a
> [<c116cd5f>] ? driver_probe_device+0x44/0xe6
> [<c116ce41>] ? __driver_attach+0x40/0x5b
> [<c116c808>] ? bus_for_each_dev+0x37/0x5f
> [<c116cc78>] ? driver_attach+0x11/0x13
> [<c116ce01>] ? __driver_attach+0x0/0x5b
> [<c116c2fb>] ? bus_add_driver+0x8c/0x1bf
> [<c1112748>] ? kset_find_obj+0x20/0x4a
> [<c116d049>] ? driver_register+0x77/0xd6
> [<c110b6ea>] ? register_blkdev+0xbd/0xcc
> [<c135135a>] ? init_sr+0x20/0x39
> [<c135133a>] ? init_sr+0x0/0x39
> [<c1001045>] ? do_one_initcall+0x44/0x120
> [<c1336294>] ? kernel_init+0x115/0x162
> [<c133617f>] ? kernel_init+0x0/0x162
> [<c1002af6>] ? kernel_thread_helper+0x6/0x10
> ---[ end trace e72efb15e7d230f6 ]---
> really_probe: driver_sysfs_add(0:0:0:0) failed
> sr: probe of 0:0:0:0 failed with error 0
>
>
>           Ruben
>
> -- 
> Ruben Puettmann
> ruben@puettmann.net
> http://www.puettmann.net
> <config-2.6.33>

