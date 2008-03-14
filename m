Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYCNBGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYCNBGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYCNBF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:05:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:54045 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbYCNBF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,497,1199692800"; 
   d="scan'208";a="533638512"
Subject: Re: [2.6.25-rc5-mm1] WARNING: at drivers/base/sys.c:173
From: Zhao Yakui <yakui.zhao@intel.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-acpi@vger.kernel.org
In-Reply-To: <47D9C04E.3060208@imap.cc>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D87238.8080305@imap.cc> <20080313195656.GA32463@codemonkey.org.uk>
	 <47D9C04E.3060208@imap.cc>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 08:57:11 +0800
Message-Id: <1205456231.4082.2.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 01:01 +0100, Tilman Schmidt wrote:
> Am 13.03.2008 20:56 schrieb Dave Jones:
> 
> >  > [   56.759128] ------------[ cut here ]------------
> >  > [   56.765058] WARNING: at drivers/base/sys.c:173 sysdev_driver_register+0x34/0xce()
> >  > [   56.776027] Modules linked in: acpi_cpufreq(+) speedstep_lib ip6table_filter ip6_tables x_tables ipv6 microcode firmware_class loop osst st sr_mod cdrom pata_acpi bas_gigaset snd_hda_intel gigaset isdn snd_pcm ata_generic<6>ip_tables: (C) 2000-2006 Netfilter Core Team
> >  > [   56.785293]  snd_timer aic7xxx slhc snd ohci1394 rtc_cmos ieee1394 shpchp crc_ccitt iTCO_wdt e1000e rtc_core iTCO_vendor_support soundcore scsi_transport_spi watchdog_core pci_hotplug intel_agp button thermal agpgart rtc_lib processor i2c_i801 watchdog_dev parport_pc i2c_core snd_page_alloc parport pata_marvell sg ext3 jbd mbcache linear sd_mod usbhid hid ff_memless ahci libata scsi_mod ehci_hcd uhci_hcd usbcore dm_snapshot dm_mod
> >  > [   56.805358] Pid: 2856, comm: modprobe Not tainted 2.6.25-rc5-mm1-testing #1
> >  > [   56.810766]  [<c01272e9>] warn_on_slowpath+0x41/0x6d
> >  > [   56.820628]  [<c0230065>] ? acpi_ns_lookup+0x2b5/0x497
> >  > [   56.830455]  [<c0230e25>] ? acpi_evaluate_object+0x23e/0x249
> >  > [   56.840414]  [<c02ff809>] ? mutex_unlock+0x8/0xa
> >  > [   56.848380]  [<fa9fec1d>] ? acpi_processor_preregister_performance+0x4e6/0x4f1 [processor]
> >  > [   56.858297]  [<c0286438>] ? cpufreq_register_driver+0x42/0xfc
> >  > [   56.868263]  [<c026423d>] sysdev_driver_register+0x34/0xce
> >  > [   56.877974]  [<c0286476>] cpufreq_register_driver+0x80/0xfc
> >  > [   56.887327]  [<facde034>] acpi_cpufreq_init+0x34/0x3a [acpi_cpufreq]
> >  > [   56.897290]  [<c014ad7a>] sys_init_module+0x1816/0x1943
> >  > [   56.907304]  [<facb5000>] ? icmp_checkentry+0x0/0x14 [ip_tables]
> >  > [   56.917255]  [<c0183cd2>] ? sys_read+0x3b/0x60
> >  > [   56.925094]  [<c0106aec>] sysenter_past_esp+0x6d/0xc5
> >  > [   56.935071]  =======================
> >  > [   56.945016] ---[ end trace 9ade9adb26b6da0a ]---
> 
> > Full dmesg please, with CPU_FREQ_DEBUG=y, and boot with cpufreq.debug=7
> 
> You can find it at
> http://gollum.phnxsoft.com/~ts/linux/dmesg.out
> and the corresponding .config right beside it at
> http://gollum.phnxsoft.com/~ts/linux/config-2.6.25-rc5-mm1
> 
> CCing linux-acpi as you did in your other mail.

Please set CONFIG_ACPI_DEBUG and boot the system with the option of
"acpi.debug_layer=0x01010000 acpi.debug_level=0x1f".

It will be great if the acpidump output is attached.

Thanks.

> HTH
> T.
> 

