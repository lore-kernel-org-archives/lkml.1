Return-Path: <linux-kernel-owner+w=401wt.eu-S1765446AbYEAX6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765446AbYEAX6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYEAX6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:58:32 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:48417 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbYEAX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:58:31 -0400
Message-ID: <002d01c8abe7$415ce060$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Cc: <len.brown@intel.com>, <linux-acpi@vger.kernel.org>
Subject: modprobe acpi-cpufreq - prints WARNING and taints kernel
Date: Fri, 2 May 2008 01:58:29 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX1/u+eVU3PFLM0zLF5Uf5U2buii67ln3FqqM6EWg
	Rww6R5FV/meKHpQK0aRQmNfiT6agsAz2YgNaK2x/eEZmjeZ9me
	ZkMHhQ+Y4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git17 on vmware - modprobe acpi-cpufreq gives the warning below.
that also didn`t happen with earlier kernels - so maybe it`s a regression, 
too.


May  2 01:40:21 opensuse103 kernel: ACPI: ACPI0007:00 is registered as 
cooling_device0
May  2 01:40:21 opensuse103 kernel: ACPI: Processor [CPU0] (supports 8 
throttling states)
May  2 01:40:24 opensuse103 kernel: sysdev: class cpu: driver (c037d1c0) has 
already been registered to a class, something is wrong, but will forge on!
May  2 01:40:24 opensuse103 kernel: ------------[ cut here ]------------
May  2 01:40:24 opensuse103 kernel: WARNING: at drivers/base/sys.c:183 
sysdev_driver_register+0x56/0xe9()
May  2 01:40:24 opensuse103 kernel: Modules linked in: acpi_cpufreq(+) 
processor zatm ovcamchip i2c_core via82cxxx vga16fb vgastate uPD98402 trm290 
triflex michael_mic crc32c deflate zlib_deflate sha512_generic cts seed 
camellia anubis khazad cast6 cast5 lrw gf128mul aes_i586 aes_generic serpent 
blowfish sha256_generic md4 cbc des_generic sha1_generic md5 snd_seq_dummy 
snd_seq snd_timer snd_seq_device snd soundcore slc90e66 sis5513 siimage 
serverworks sctp libcrc32c sc1200 cfi_probe rz1000 fcrypt pcbc arc4 ecb 
crypto_blkcipher pdc202xx_old pdc202xx_new parkbd opti621 ns87415 nls_cp932 
jedec_probe gen_probe chipreg jmicron it821x it8213 ip2 ip2main ide_generic 
ide_cd_mod cdrom hpt366 hpt34x eni suni atm decnet dccp_ipv6 dccp_ipv4 dccp 
cy82c693 cs5535 cs5530 cs5520 cmd64x cmd640 capifs sunrpc atiixp ar7part mtd 
amd74xx alim15x3 aec62xx a3d gameport 9pnet_fd 9pnet 8250_hub6 8250_fourport 
8250_exar_st16c554 8250_boca 8250_accent ipv6 fuse ahci libata dock 
ide_pci_generic piix parport_pc parport pcnet32 ide_core mii intel
May  2 01:40:24 opensuse103 kernel: _agp agpgart ext3 mbcache jbd mptspi 
mptscsih mptbase scsi_transport_spi sd_mod scsi_mod [last unloaded: usbcore]
May  2 01:40:24 opensuse103 kernel: Pid: 13752, comm: modprobe Tainted: G 
W 2.6.25-git17-default #1
May  2 01:40:24 opensuse103 kernel:  [<c0121576>] warn_on_slowpath+0x40/0x67
May  2 01:40:24 opensuse103 kernel:  [<c01258e9>] irq_exit+0x53/0x6a
May  2 01:40:24 opensuse103 kernel:  [<c011142d>] 
smp_apic_timer_interrupt+0x6b/0x76
May  2 01:40:24 opensuse103 kernel:  [<c0105a18>] 
apic_timer_interrupt+0x28/0x30
May  2 01:40:24 opensuse103 kernel:  [<c0121e51>] vprintk+0x2b9/0x2cd
May  2 01:40:24 opensuse103 kernel:  [<c01cb41e>] __next_cpu+0x12/0x1e
May  2 01:40:24 opensuse103 kernel:  [<d0c55a48>] 
acpi_processor_preregister_performance+0x504/0x510 [processor]
May  2 01:40:24 opensuse103 kernel:  [<c01a662f>] sysfs_ilookup_test+0x0/0xd
May  2 01:40:24 opensuse103 kernel:  [<c016cc78>] percpu_populate+0x32/0x39
May  2 01:40:24 opensuse103 kernel:  [<c0121e79>] printk+0x14/0x18
May  2 01:40:24 opensuse103 kernel:  [<c02321d3>] 
sysdev_driver_register+0x56/0xe9
May  2 01:40:24 opensuse103 kernel:  [<c0253da1>] 
cpufreq_register_driver+0x7d/0xf9
May  2 01:40:24 opensuse103 kernel:  [<c013db4c>] 
sys_init_module+0x1694/0x17a7
May  2 01:40:24 opensuse103 kernel:  [<c01079de>] sys_mmap2+0x62/0x77
May  2 01:40:24 opensuse103 kernel:  [<c010491f>] 
sysenter_past_esp+0x78/0xb9
May  2 01:40:24 opensuse103 kernel:  =======================
May  2 01:40:24 opensuse103 kernel: ---[ end trace 570d6a1488783306 ]---





