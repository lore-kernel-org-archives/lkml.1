Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbXFVOsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbXFVOsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbXFVOr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:47:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502AbXFVOr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:47:56 -0400
Message-ID: <467BE118.4090308@redhat.com>
Date: Fri, 22 Jun 2007 10:47:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "Jay L. T. Cornwall" <jay@esuna.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc5: pdflush oops under heavy disk load
References: <467B12CA.5060405@esuna.co.uk>
In-Reply-To: <467B12CA.5060405@esuna.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2007 08:07 PM, Jay L. T. Cornwall wrote:
> Hi,
> 
> Kernel version: 2.6.22-rc5 (confirmed also on 2.6.20)
> Kernel config : Ubuntu 7.04 default (SMP)
> 
> Relevant hardware:
>   Asus P5K (Intel P35 chipset)
>   Core 2 Duo E6600 2.4GHz
>   Western Digital 10KRPM 150GB HDD on JMicron 20360/20363 AHCI
> 
> Netconsoled dump:
> 
> [  724.350222] general protection fault: 0000 [1] SMP
> [  724.350413] CPU 1
> [  724.350520] Modules linked in: usb_storage libusual netconsole
> binfmt_misc rfcomm l2cap bluetooth ppdev capability commoncap
> acpi_cpufreq cpufreq_stats cpufreq_userspace cpufreq_ondemand
> cpufreq_conservative cpufreq_powersave freq_table video container
> battery dock asus_acpi ac sbs button af_packet nls_utf8 ntfs w83627ehf
> i2c_isa parport_pc lp parport fuse mt2060 snd_hda_intel snd_pcm_oss
> snd_mixer_oss snd_pcm cx22702 snd_seq_dummy snd_seq_oss dvb_usb_dib0700
> dib7000m dib7000p dvb_usb cx88_dvb cx88_vp3054_i2c snd_seq_midi
> snd_rawmidi video_buf_dvb dvb_core ipv6 snd_seq_midi_event snd_seq
> snd_timer dvb_pll cx8800 cx8802 cx88xx sr_mod ir_common snd_seq_device
> cdrom i2c_algo_bit dib3000mc dibx000_common tveeprom atl1 usbhid psmouse
> videodev compat_ioctl32 hid mii i2c_core v4l2_common v4l1_compat
> btcx_risc video_buf serio_raw snd soundcore pcspkr shpchp pci_hotplug
> snd_page_alloc intel_agp tsdev evdev ext3 jbd mbcache sg sd_mod
> pata_jmicron ata_generic ata_piix ahci libata scsi_mod ehci_hcd generic
> uhci_hcd usbcore thermal processor fan
> [  724.355028] Pid: 199, comm: pdflush Not tainted 2.6.22-rc5-edge #1
> [  724.355125] RIP: 0010:[<ffffffff880f1b44>]  [<ffffffff880f1b44>]
> :ext3:walk_page_buffers+0x34/0x90

Step 1: run fsck on the filesystem.

