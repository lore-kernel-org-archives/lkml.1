Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYKRPR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYKRPR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYKRPRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:17:49 -0500
Received: from smtp.rent-a-mailserver.de ([217.69.77.126]:34041 "EHLO
	smtp.rent-a-mailserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYKRPRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:17:47 -0500
X-Greylist: delayed 695 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2008 10:17:47 EST
X-DKIM: Sendmail DKIM Filter v2.6.0 smtp.rent-a-mailserver.de mAIF5x7h024210
Message-ID: <4922D9D5.2020507@schulte.it>
Date: Tue, 18 Nov 2008 16:05:57 +0100
From: Christian Schulte <cs@schulte.it>
User-Agent: Icedove 1.5.0.14eol (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: WARNING: at net/mac80211/rx.c:388 __ieee80211_rx_handle_packet+0x1fe/0x627
 [mac80211]()
Content-Type: multipart/mixed;
 boundary="------------040204080103090004050702"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (smtp.rent-a-mailserver.de [217.69.77.126]); Tue, 18 Nov 2008 16:06:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040204080103090004050702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

this is with the 2.6.27.6 iwl3945 module. Is it some misconfiguration on
my side ?


-- 
Christian


--------------040204080103090004050702
Content-Type: text/x-log;
 name="kern.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kern.log"

Nov 15 21:45:30 r60 kernel: ADDRCONF(NETDEV_CHANGE): wlan0_rename: link becomes ready
Nov 15 21:45:35 r60 kernel: ------------[ cut here ]------------
Nov 15 21:45:35 r60 kernel: WARNING: at net/mac80211/rx.c:388 __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]()
Nov 15 21:45:35 r60 kernel: Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables binfmt_misc fglrx(P) rfcomm l2cap uinput ipv6 ppdev parport_pc lp parport dm_snapshot dm_mirror dm_log dm_mod sbp2 loop pcmcia hci_usb joydev arc4 ecb crypto_blkcipher battery bluetooth ac bay video output psmouse yenta_socket rsrc_nonstatic serio_raw iwl3945 pcmcia_core mac80211 cfg80211 button snd_hda_intel snd_pcm snd_seq snd_timer snd_seq_device rng_core i2c_i801 snd iTCO_wdt pcspkr intel_agp soundcore snd_page_alloc agpgart evdev xfs sd_mod crc_t10dif ide_cd_mod cdrom ata_generic ata_piix ahci libata usbhid piix hid ohci1394 ide_core scsi_mod ff_memless ieee1394 dock tg3 libphy thermal fan ohci_hcd uhci_hcd ehci_hcd usbcore radeonfb fb_ddc i2c_algo_bit i2c_core acpi_cpufreq freq_table processor thermal_sys thinkpad_acpi rfkill led_class nvram
Nov 15 21:45:35 r60 kernel: Pid: 11033, comm: clamd Tainted: P          2.6.27.6-workstation #1
Nov 15 21:45:35 r60 kernel:  [<c0123d26>] warn_on_slowpath+0x40/0x63
Nov 15 21:45:35 r60 kernel:  [<f9684817>] ieee80211_wep_decrypt_data+0x72/0x81 [mac80211]
Nov 15 21:45:35 r60 kernel:  [<c02caa65>] __lock_text_start+0x2d/0x33
Nov 15 21:45:35 r60 kernel:  [<c026166b>] skb_queue_tail+0x11/0x2d
Nov 15 21:45:35 r60 kernel:  [<f968ee00>] ieee80211_rx_irqsafe+0x2c/0x4f [mac80211]
Nov 15 21:45:35 r60 kernel:  [<f975dc90>] iwl3945_pass_packet_to_mac80211+0x260/0x272 [iwl3945]
Nov 15 21:45:35 r60 kernel:  [<f968f410>] ieee80211_rx_h_data+0x26/0x62 [mac80211]
Nov 15 21:45:35 r60 kernel:  [<f9690a0c>] __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]
Nov 15 21:45:35 r60 kernel:  [<f9691529>] __ieee80211_rx+0x48e/0x4f9 [mac80211]
Nov 15 21:45:35 r60 kernel:  [<f9750ca2>] iwl3945_rx_queue_restock+0x9a/0x117 [iwl3945]
Nov 15 21:45:35 r60 kernel:  [<f9681353>] ieee80211_tasklet_handler+0x49/0xc2 [mac80211]
Nov 15 21:45:35 r60 kernel:  [<c0127f87>] tasklet_action+0x68/0xce
Nov 15 21:45:35 r60 kernel:  [<c0127a19>] __do_softirq+0x66/0xd3
Nov 15 21:45:35 r60 kernel:  [<c0127acb>] do_softirq+0x45/0x53
Nov 15 21:45:35 r60 kernel:  [<c0127c70>] irq_exit+0x35/0x73
Nov 15 21:45:35 r60 kernel:  [<c01061a4>] do_IRQ+0x54/0x68
Nov 15 21:45:35 r60 kernel:  [<c010437f>] common_interrupt+0x23/0x28
Nov 15 21:45:35 r60 kernel:  =======================
Nov 15 21:45:35 r60 kernel: ---[ end trace 92e1ab8c7c81fa88 ]---
Nov 16 22:03:51 r60 kernel: ------------[ cut here ]------------
Nov 16 22:03:51 r60 kernel: WARNING: at net/mac80211/rx.c:388 __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]()
Nov 16 22:03:51 r60 kernel: Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables binfmt_misc fglrx(P) rfcomm l2cap uinput ipv6 ppdev parport_pc lp parport dm_snapshot dm_mirror dm_log dm_mod sbp2 loop arc4 joydev ecb crypto_blkcipher pcmcia hci_usb bluetooth battery ac bay video output psmouse serio_raw iwl3945 yenta_socket rsrc_nonstatic pcmcia_core mac80211 cfg80211 button snd_hda_intel snd_pcm snd_seq rng_core snd_timer snd_seq_device snd i2c_i801 iTCO_wdt soundcore snd_page_alloc intel_agp pcspkr agpgart evdev xfs ide_cd_mod cdrom sd_mod crc_t10dif ata_generic ata_piix ahci piix ohci1394 libata ieee1394 ide_core scsi_mod dock tg3 libphy thermal fan ohci_hcd uhci_hcd ehci_hcd usbcore radeonfb fb_ddc i2c_algo_bit i2c_core acpi_cpufreq freq_table processor thermal_sys thinkpad_acpi rfkill led_class nvram
Nov 16 22:03:51 r60 kernel: Pid: 4872, comm: clamd Tainted: P          2.6.27.6-workstation #1
Nov 16 22:03:51 r60 kernel:  [<c0123d26>] warn_on_slowpath+0x40/0x63
Nov 16 22:03:51 r60 kernel:  [<f9716817>] ieee80211_wep_decrypt_data+0x72/0x81 [mac80211]
Nov 16 22:03:51 r60 kernel:  [<c02caa65>] __lock_text_start+0x2d/0x33
Nov 16 22:03:51 r60 kernel:  [<c026166b>] skb_queue_tail+0x11/0x2d
Nov 16 22:03:51 r60 kernel:  [<f9720e00>] ieee80211_rx_irqsafe+0x2c/0x4f [mac80211]
Nov 16 22:03:51 r60 kernel:  [<f9754c90>] iwl3945_pass_packet_to_mac80211+0x260/0x272 [iwl3945]
Nov 16 22:03:51 r60 kernel:  [<f9721410>] ieee80211_rx_h_data+0x26/0x62 [mac80211]
Nov 16 22:03:51 r60 kernel:  [<f9722a0c>] __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]
Nov 16 22:03:51 r60 kernel:  [<f9723529>] __ieee80211_rx+0x48e/0x4f9 [mac80211]
Nov 16 22:03:51 r60 kernel:  [<f9747ca2>] iwl3945_rx_queue_restock+0x9a/0x117 [iwl3945]
Nov 16 22:03:51 r60 kernel:  [<f9713353>] ieee80211_tasklet_handler+0x49/0xc2 [mac80211]
Nov 16 22:03:51 r60 kernel:  [<c0127f87>] tasklet_action+0x68/0xce
Nov 16 22:03:51 r60 kernel:  [<c0127a19>] __do_softirq+0x66/0xd3
Nov 16 22:03:51 r60 kernel:  [<c0127acb>] do_softirq+0x45/0x53
Nov 16 22:03:51 r60 kernel:  [<c0127c70>] irq_exit+0x35/0x73
Nov 16 22:03:51 r60 kernel:  [<c01061a4>] do_IRQ+0x54/0x68
Nov 16 22:03:51 r60 kernel:  [<c010437f>] common_interrupt+0x23/0x28
Nov 16 22:03:51 r60 kernel:  =======================
Nov 16 22:03:51 r60 kernel: ---[ end trace 9f939e3cba40957b ]---
Nov 16 23:40:40 r60 kernel: ------------[ cut here ]------------
Nov 16 23:40:40 r60 kernel: WARNING: at net/mac80211/rx.c:388 __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]()
Nov 16 23:40:40 r60 kernel: Modules linked in: iwl3945 mac80211 ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables binfmt_misc fglrx(P) rfcomm l2cap uinput ipv6 ppdev parport_pc lp parport dm_snapshot dm_mirror dm_log dm_mod sbp2 loop arc4 joydev ecb crypto_blkcipher pcmcia hci_usb bluetooth battery ac bay video output psmouse serio_raw yenta_socket rsrc_nonstatic pcmcia_core cfg80211 button snd_hda_intel snd_pcm snd_seq rng_core snd_timer snd_seq_device snd i2c_i801 iTCO_wdt soundcore snd_page_alloc intel_agp pcspkr agpgart evdev xfs ide_cd_mod cdrom sd_mod crc_t10dif ata_generic ata_piix ahci piix ohci1394 libata ieee1394 ide_core scsi_mod dock tg3 libphy thermal fan ohci_hcd uhci_hcd ehci_hcd usbcore radeonfb fb_ddc i2c_algo_bit i2c_core acpi_cpufreq freq_table processor thermal_sys thinkpad_acpi rfkill led_class nvram [last unloaded: mac80211]
Nov 16 23:40:40 r60 kernel: Pid: 0, comm: swapper Tainted: P        W 2.6.27.6-workstation #1
Nov 16 23:40:40 r60 kernel:  [<c0123d26>] warn_on_slowpath+0x40/0x63
Nov 16 23:40:40 r60 kernel:  [<f9996062>] ieee80211_data_to_8023+0x5e/0x2fd [mac80211]
Nov 16 23:40:40 r60 kernel:  [<c02caa65>] __lock_text_start+0x2d/0x33
Nov 16 23:40:40 r60 kernel:  [<c026166b>] skb_queue_tail+0x11/0x2d
Nov 16 23:40:40 r60 kernel:  [<f9995e00>] ieee80211_rx_irqsafe+0x2c/0x4f [mac80211]
Nov 16 23:40:40 r60 kernel:  [<f9754c90>] iwl3945_pass_packet_to_mac80211+0x260/0x272 [iwl3945]
Nov 16 23:40:40 r60 kernel:  [<f9997a0c>] __ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]
Nov 16 23:40:40 r60 kernel:  [<f9998529>] __ieee80211_rx+0x48e/0x4f9 [mac80211]
Nov 16 23:40:40 r60 kernel:  [<f9747ca2>] iwl3945_rx_queue_restock+0x9a/0x117 [iwl3945]
Nov 16 23:40:40 r60 kernel:  [<f9988353>] ieee80211_tasklet_handler+0x49/0xc2 [mac80211]
Nov 16 23:40:40 r60 kernel:  [<c0127f87>] tasklet_action+0x68/0xce
Nov 16 23:40:40 r60 kernel:  [<c0127a19>] __do_softirq+0x66/0xd3
Nov 16 23:40:40 r60 kernel:  [<c0127acb>] do_softirq+0x45/0x53
Nov 16 23:40:40 r60 kernel:  [<c0127c70>] irq_exit+0x35/0x73
Nov 16 23:40:40 r60 kernel:  [<c01061a4>] do_IRQ+0x54/0x68
Nov 16 23:40:40 r60 kernel:  [<c010437f>] common_interrupt+0x23/0x28
Nov 16 23:40:40 r60 kernel:  [<f88481c3>] acpi_idle_enter_bm+0x2ae/0x323 [processor]
Nov 16 23:40:40 r60 kernel:  [<c0256ef6>] cpuidle_idle_call+0x5b/0x89
Nov 16 23:40:40 r60 kernel:  [<c010266b>] cpu_idle+0xde/0x112
Nov 16 23:40:40 r60 kernel:  =======================
Nov 16 23:40:40 r60 kernel: ---[ end trace 9f939e3cba40957b ]---

--------------040204080103090004050702--
