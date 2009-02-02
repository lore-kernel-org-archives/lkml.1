Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbZBBV62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbZBBV62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbZBBV6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:58:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35360 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759080AbZBBV6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:58:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miles Lane <miles.lane@gmail.com>
Subject: Re: 2.6.29-rc3-git3 -- WARNING: at drivers/pci/pci-driver.c:368 pci_legacy_suspend+0x7e/0xbb()
Date: Mon, 2 Feb 2009 22:57:36 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a44ae5cd0902021331u715b7068s2e43440e3a180966@mail.gmail.com>
In-Reply-To: <a44ae5cd0902021331u715b7068s2e43440e3a180966@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902022257.36541.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Miles Lane wrote:
> udev: starting version 137
> udev: deprecated sysfs layout; update the kernel or disable
> CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
> ...
> pci 0000:00:02.0: PCI INT A disabled
> ACPI handle has no context!
> ACPI handle has no context!
> tifm_7xx1 0000:04:09.2: PME# disabled
> tifm_7xx1 0000:04:09.2: PCI INT A disabled
> ACPI handle has no context!
> ieee1394: hpsb_bus_reset called while bus reset already in progress
> ACPI handle has no context!
> ------------[ cut here ]------------
> WARNING: at drivers/pci/pci-driver.c:368 pci_legacy_suspend+0x7e/0xbb()
> Hardware name: MT6821
> Modules linked in: ipv6 binfmt_misc sco bridge stp llc rfcomm bnep
> l2cap bluetooth acpi_cpufreq cpufreq_ondemand cpufreq_stats
> cpufreq_performance freq_table cpufreq_powersave pci_slot sbs sbshc
> sbp2 ppdev parport_pc lp parport snd_hda_codec_si3054
> snd_hda_codec_idt snd_hda_intel snd_hda_codec joydev snd_hwdep
> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi arc4
> snd_rawmidi ecb snd_seq_midi_event pcmcia snd_seq snd_timer iwl3945
> snd_seq_device rfkill rng_core snd mac80211 yenta_socket iTCO_wdt
> led_class iTCO_vendor_support tifm_7xx1 rsrc_nonstatic rtc_cmos
> rtc_core battery psmouse lib80211 tifm_core pcmcia_core rtc_lib
> soundcore button ac cfg80211 evdev snd_page_alloc sr_mod ohci1394
> cdrom ehci_hcd ieee1394 uhci_hcd usbcore sky2 thermal processor fan
> thermal_sys hwmon fuse
> Pid: 4052, comm: pm-suspend Not tainted 2.6.29-rc3-git3 #1
> Call Trace:
>  [<ffffffff8023ac8f>] warn_slowpath+0xd3/0x10f
>  [<ffffffff803c5709>] ? acpi_bus_data_handler+0x0/0x6
>  [<ffffffff80514c94>] ? _spin_unlock_irqrestore+0x4e/0x5c
>  [<ffffffff80252614>] ? up+0x34/0x39
>  [<ffffffff80396c4b>] ? acpi_os_signal_semaphore+0x66/0x6f
>  [<ffffffff803c5709>] ? acpi_bus_data_handler+0x0/0x6
>  [<ffffffff803c3381>] ? acpi_ut_release_mutex+0xad/0xb6
>  [<ffffffff803b2a5a>] ? acpi_get_data+0x5e/0x70
>  [<ffffffff803c5709>] ? acpi_bus_data_handler+0x0/0x6
>  [<ffffffff8037e6dc>] ? pcie_aspm_pm_state_change+0x35/0x37
>  [<ffffffff803c4e3c>] ? acpi_bus_power_manageable+0x11/0x29
>  [<ffffffff80386d12>] ? acpi_pci_power_manageable+0x17/0x19
>  [<ffffffff8037920f>] ? pci_set_power_state+0xcc/0x101
>  [<ffffffff8037b5fe>] pci_legacy_suspend+0x7e/0xbb
>  [<ffffffff8037b734>] pci_pm_suspend+0x37/0x89
>  [<ffffffff804268ae>] pm_op+0x52/0xe5
>  [<ffffffff80426e4d>] device_suspend+0x31f/0x433
>  [<ffffffff8026554b>] suspend_devices_and_enter+0x44/0x17f
>  [<ffffffff80265812>] enter_state+0x163/0x1c9
>  [<ffffffff8026592f>] state_store+0xb7/0xd8
>  [<ffffffff803689c7>] kobj_attr_store+0x17/0x19
>  [<ffffffff802f2748>] sysfs_write_file+0xe4/0x119
>  [<ffffffff802a765f>] vfs_write+0xa7/0xe1
>  [<ffffffff802a775d>] sys_write+0x47/0x6f
>  [<ffffffff8020b85b>] system_call_fastpath+0x16/0x1b
> ---[ end trace d408bf0623d224f9 ]---
> sky2 0000:02:00.0: PME# disabled
> ahci 0000:00:1f.2: power state changed by ACPI to D3
> ata6: port disabled. ignoring.
> ata_piix 0000:00:1f.1: PCI INT B disabled
> ehci_hcd 0000:00:1d.7: PCI INT A disabled
> ehci_hcd 0000:00:1d.7: PME# disabled
> ehci_hcd 0000:00:1d.7: wakeup: 0
> ehci_hcd 0000:00:1d.7: --> PCI D3
> uhci_hcd 0000:00:1d.3: uhci_pci_suspend
> uhci_hcd 0000:00:1d.3: PCI INT D disabled
> uhci_hcd 0000:00:1d.3: wakeup: 0

Please have a look at this thread:
http://lkml.org/lkml/2009/2/1/49

Thanks,
Rafael
