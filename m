Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbYFQM2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbYFQM2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYFQM2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:28:42 -0400
Received: from userg501.nifty.com ([202.248.238.81]:29721 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbYFQM2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:28:40 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=wFHykoM3twGjALc6VNSiKQpnpNHxjHluzxRIEJQPYRFp9UUoXUJLSVJ4sJLtRXee4
	RW6P5Pmx6xBElMmg7Tv1w==
X-Nifty-SrcIP: [220.145.30.185]
Date: Tue, 17 Jun 2008 21:23:45 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk
 Extreme III 8GB
Message-Id: <20080617212345.c452d8c5.komurojun-mbn@nifty.com>
In-Reply-To: <485669A0.6000404@gmail.com>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>
	<20080528222740.GB20893@isilmar.linta.de>
	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
	<20080607223716.7d142072.komurojun-mbn@nifty.com>
	<20080611072029.GB28692@comet.dominikbrodowski.net>
	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
	<48537149.4040102@garzik.org>
	<20080614213612.96873c25.komurojun-mbn@nifty.com>
	<4855D8E2.10409@gmail.com>
	<20080616221145.e3b069b9.komurojun-mbn@nifty.com>
	<485669A0.6000404@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the log again.

pcmcia: registering new device pcmcia0.0
pata_pcmcia 0.0: XXX ENTER
Pid: 1648, comm: modprobe Not tainted 2.6.26-rc5 #3
 [<d885314f>] pcmcia_init_one+0x34/0x585 [pata_pcmcia]
 [<c0559444>] pccard_get_tuple_data+0x53/0x5c
 [<c0476a1a>] iput+0x2a/0x4a
 [<c055b156>] pcmcia_device_probe+0xa6/0xf6
 [<c0538d00>] driver_probe_device+0x103/0x12c
 [<c0538d29>] __driver_attach+0x0/0x55
 [<c0538cb2>] driver_probe_device+0xb5/0x12c
 [<c0538d60>] __driver_attach+0x37/0x55
 [<c05385fb>] bus_for_each_dev+0x37/0x59
 [<c0538b4d>] driver_attach+0x11/0x13
 [<c0538d29>] __driver_attach+0x0/0x55
 [<c053894f>] bus_add_driver+0x8a/0x1a7
 [<c04d2db0>] kset_find_obj+0x20/0x4b
 [<c0538f41>] driver_register+0x6d/0xc1
 [<c055b8d0>] pcmcia_register_driver+0xaf/0xdb
 [<c043b932>] sys_init_module+0x1844/0x19b4
 [<c055c3db>] pcmcia_request_irq+0x0/0x1d6
 [<c0403815>] sysenter_past_esp+0x6a/0x91
 =======================
scsi2 : pata_pcmcia
ata3: PATA max PIO0 cmd 0xd100 ctl 0xd10e irq 3
ata3.00: CFA: , Ver.1.0, max PIO2
ata3.00: 32000 sectors, multi 0: LBA 
ata3.00: configured for PIO0
ata3.00: configured for PIO0
ata3: EH complete
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access     ATA                       Ver. PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
pata_pcmcia 0.0: XXX LEAVE 0
pcmcia: registering new device pcmcia0.1
pata_pcmcia 0.1: XXX ENTER
Pid: 6, comm: events/0 Not tainted 2.6.26-rc5 #3
 [<d885314f>] pcmcia_init_one+0x34/0x585 [pata_pcmcia]
 [<c0559444>] pccard_get_tuple_data+0x53/0x5c
 [<c055b156>] pcmcia_device_probe+0xa6/0xf6
 [<c0538cb2>] driver_probe_device+0xb5/0x12c
 [<c0538d7e>] __device_attach+0x0/0x5
 [<c05383e9>] bus_for_each_drv+0x36/0x5e
 [<c0538dec>] device_attach+0x4e/0x5e
 [<c0538d7e>] __device_attach+0x0/0x5
 [<c053827c>] bus_attach_device+0x1e/0x46
 [<c05376fa>] device_add+0x310/0x43d
 [<c055b5ab>] pcmcia_device_add+0x188/0x1eb
 [<c055b60e>] pcmcia_delayed_add_device+0x0/0x23
 [<c055b628>] pcmcia_delayed_add_device+0x1a/0x23
 [<c042b735>] run_workqueue+0x6b/0xe0
 [<c042bddf>] worker_thread+0x0/0xbd
 [<c042be92>] worker_thread+0xb3/0xbd
 [<c042e000>] autoremove_wake_function+0x0/0x2d
 [<c042df3e>] kthread+0x38/0x5e
 [<c042df06>] kthread+0x0/0x5e
 [<c0404407>] kernel_thread_helper+0x7/0x10
 =======================
0.1: GetNextTuple: No more items
pata_pcmcia 0.1: XXX LEAVE -12
pata_pcmcia: probe of 0.1 failed with error -12
modprobe used greatest stack depth: 1676 bytes left
pata_pcmcia 0.1: XXX ENTER
Pid: 1661, comm: sh Not tainted 2.6.26-rc5 #3
 [<d885314f>] pcmcia_init_one+0x34/0x585 [pata_pcmcia]
 [<c0559444>] pccard_get_tuple_data+0x53/0x5c
 [<c0476a1a>] iput+0x2a/0x4a
 [<c055b156>] pcmcia_device_probe+0xa6/0xf6
 [<c0538000>] bus_register_notifier+0x2/0xb
 [<c0538063>] bus_rescan_devices_helper+0x0/0x44
 [<c0538cb2>] driver_probe_device+0xb5/0x12c
 [<c0538d7e>] __device_attach+0x0/0x5
 [<c05383e9>] bus_for_each_drv+0x36/0x5e
 [<c0538dec>] device_attach+0x4e/0x5e
 [<c0538d7e>] __device_attach+0x0/0x5
 [<c053808a>] bus_rescan_devices_helper+0x27/0x44
 [<c05385fb>] bus_for_each_dev+0x37/0x59
 [<c053862b>] bus_rescan_devices+0xe/0x10
 [<c0538063>] bus_rescan_devices_helper+0x0/0x44
 [<c055a8f2>] pcmcia_store_allow_func_id_match+0x46/0x5b
 [<c055a8ac>] pcmcia_store_allow_func_id_match+0x0/0x5b
 [<c05369d6>] dev_attr_store+0x19/0x1d
 [<c04997a0>] sysfs_write_file+0xa4/0xd8
 [<c04996fc>] sysfs_write_file+0x0/0xd8
 [<c0467a3d>] vfs_write+0x83/0x114
 [<c0467ff6>] sys_write+0x3c/0x63
 [<c0403815>] sysenter_past_esp+0x6a/0x91
 =======================
0.1: GetNextTuple: No more items
pata_pcmcia 0.1: XXX LEAVE -12
pata_pcmcia: probe of 0.1 failed with error -12


Best Regards
Komuro


> > 
> > Here is the log  (your patch is applied).
> > Unfortunately, no message that you added appears.
> > 
> > It seems this device is detected as pcmcia0.0 first
> > but later it is detected as pcmcia0.1.
> 
> Hmmm... strange.  Can you please try the attached patch?
> 
> -- 
> tejun
> 


-- 
Komuro <komurojun-mbn@nifty.com>
