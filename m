Return-Path: <linux-kernel-owner+w=401wt.eu-S933775AbYEFWjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbYEFWjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbYEFWjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:39:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56757 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933896AbYEFWjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:39:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x7a
Date: Wed, 7 May 2008 00:39:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
References: <20080422075357.GA15651@elte.hu> <1208855066.4695.17.camel@marge.simson.net>
In-Reply-To: <1208855066.4695.17.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070039.20120.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 of April 2008, Mike Galbraith wrote:
> 
> On Tue, 2008-04-22 at 09:53 +0200, Ingo Molnar wrote:
> > hi Len,
> > 
> > randconfig boot testing found this new debug warning message in the 
> > syslog:
> 
> Ditto with Q6600 and v2.6.25-3410-g8075014.

Does it still happen with the current -git?

> [   28.360968] sysdev: class cpu: driver (ffffffff80542a70) has already been registered to a class, something is wrong, but will forge on!
> [   28.379718] ------------[ cut here ]------------
> [   28.387748] WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x75/0x12c()
> [   28.398816] Modules linked in: acpi_cpufreq(+) snd_pcm_oss snd_mixer_oss snd_seq microcode snd_seq_device nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod tda1004x saa7134_dvb videobuf_dvb dvb_core tuner tea5767 tda8290 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 snd_hda_intel saa7134 firewire_ohci snd_pcm firewire_core compat_ioctl32 crc_itu_t videodev snd_timer v4l1_compat snd_page_alloc snd_hwdep v4l2_common snd videobuf_dma_sg ohci1394 videobuf_core usbhid usb_storage e1000e rtc_cmos ieee1394 rtc_core ir_kbd_i2c hid iTCO_wdt sr_mod soundcore ir_common rtc_lib tveeprom button i2c_i801 serio_raw cdrom intel_agp ff_memless sg i2c_core iTCO_vendor_support ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
> [   28.514728] Pid: 2910, comm: modprobe Not tainted 2.6.26-smp #4
> [   28.525112] 
> [   28.525113] Call Trace:
> [   28.537784]  [<ffffffff802327b3>] warn_on_slowpath+0x58/0x6b
> [   28.547864]  [<ffffffff80233595>] ? printk+0x67/0x69
> [   28.557169]  [<ffffffffa000387a>] ? :processor:acpi_processor_preregister_performance+0x40f/0x421
> [   28.570438]  [<ffffffff803701ff>] sysdev_driver_register+0x75/0x12c
> [   28.581048]  [<ffffffff80392ab0>] cpufreq_register_driver+0x95/0x12c
> [   28.591770]  [<ffffffffa00ea03f>] :acpi_cpufreq:acpi_cpufreq_init+0x3f/0x41
> [   28.603226]  [<ffffffff802543a0>] sys_init_module+0x19db/0x1b08
> [   28.614176]  [<ffffffff8028dec3>] ? vfs_read+0xab/0x154
> [   28.624319]  [<ffffffff8020c01b>] system_call_after_swapgs+0x7b/0x80
> [   28.624326] 
> [   28.624328] ---[ end trace a40285f696d317dc ]---
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
