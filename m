Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYKTAxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYKTAxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 19:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYKTAxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 19:53:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbYKTAxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 19:53:43 -0500
Date: Wed, 19 Nov 2008 16:53:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Schulte <cs@schulte.it>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/mac80211/rx.c:388
 __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]()
Message-Id: <20081119165329.15e5a6d4.akpm@linux-foundation.org>
In-Reply-To: <4922D9D5.2020507@schulte.it>
References: <4922D9D5.2020507@schulte.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-wireless)

On Tue, 18 Nov 2008 16:05:57 +0100
Christian Schulte <cs@schulte.it> wrote:

> this is with the 2.6.27.6 iwl3945 module. Is it some misconfiguration on
> my side ?
> 
> 
> -- 
> Christian
> 
> 
> 
> [kern.log  text/x-log (7.7KB)]
> Nov 15 21:45:30 r60 kernel: ADDRCONF(NETDEV_CHANGE): wlan0_rename: link becomes ready
> Nov 15 21:45:35 r60 kernel: ------------[ cut here ]------------
> Nov 15 21:45:35 r60 kernel: WARNING: at net/mac80211/rx.c:388 __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]()
> Nov 15 21:45:35 r60 kernel: Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables binfmt_misc fglrx(P) rfcomm l2cap uinput ipv6 ppdev parport_pc lp parport dm_snapshot dm_mirror dm_log dm_mod sbp2 loop pcmcia hci_usb joydev arc4 ecb crypto_blkcipher battery bluetooth ac bay video output psmouse yenta_socket rsrc_nonstatic serio_raw iwl3945 pcmcia_core mac80211 cfg80211 button snd_hda_intel snd_pcm snd_seq snd_timer snd_seq_device rng_core i2c_i801 snd iTCO_wdt pcspkr intel_agp soundcore snd_page_alloc agpgart evdev xfs sd_mod crc_t10dif ide_cd_mod cdrom ata_generic ata_piix ahci libata usbhid piix hid ohci1394 ide_core scsi_mod ff_memless ieee1394 dock tg3 libphy thermal fan ohci_hcd uhci_hcd ehci_hcd usbcore radeonfb fb_ddc i2c_algo_bit i2c_core acpi_cpufreq freq_table processor thermal_sys thinkpad_acpi rfkill led_class nvram
> Nov 15 21:45:35 r60 kernel: Pid: 11033, comm: clamd Tainted: P          2.6.27.6-workstation #1
> Nov 15 21:45:35 r60 kernel:  [<c0123d26>] warn_on_slowpath+0x40/0x63
> Nov 15 21:45:35 r60 kernel:  [<f9684817>] ieee80211_wep_decrypt_data+0x72/0x81 [mac80211]
> Nov 15 21:45:35 r60 kernel:  [<c02caa65>] __lock_text_start+0x2d/0x33
> Nov 15 21:45:35 r60 kernel:  [<c026166b>] skb_queue_tail+0x11/0x2d
> Nov 15 21:45:35 r60 kernel:  [<f968ee00>] ieee80211_rx_irqsafe+0x2c/0x4f [mac80211]
> Nov 15 21:45:35 r60 kernel:  [<f975dc90>] iwl3945_pass_packet_to_mac80211+0x260/0x272 [iwl3945]
> Nov 15 21:45:35 r60 kernel:  [<f968f410>] ieee80211_rx_h_data+0x26/0x62 [mac80211]
> Nov 15 21:45:35 r60 kernel:  [<f9690a0c>] __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]
> Nov 15 21:45:35 r60 kernel:  [<f9691529>] __ieee80211_rx+0x48e/0x4f9 [mac80211]
> Nov 15 21:45:35 r60 kernel:  [<f9750ca2>] iwl3945_rx_queue_restock+0x9a/0x117 [iwl3945]
> Nov 15 21:45:35 r60 kernel:  [<f9681353>] ieee80211_tasklet_handler+0x49/0xc2 [mac80211]
> Nov 15 21:45:35 r60 kernel:  [<c0127f87>] tasklet_action+0x68/0xce
> Nov 15 21:45:35 r60 kernel:  [<c0127a19>] __do_softirq+0x66/0xd3
> Nov 15 21:45:35 r60 kernel:  [<c0127acb>] do_softirq+0x45/0x53
> Nov 15 21:45:35 r60 kernel:  [<c0127c70>] irq_exit+0x35/0x73
> Nov 15 21:45:35 r60 kernel:  [<c01061a4>] do_IRQ+0x54/0x68
> Nov 15 21:45:35 r60 kernel:  [<c010437f>] common_interrupt+0x23/0x28
> Nov 15 21:45:35 r60 kernel:  =======================
> Nov 15 21:45:35 r60 kernel: ---[ end trace 92e1ab8c7c81fa88 ]---
