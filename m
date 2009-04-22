Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZDVKdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZDVKdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZDVKdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:33:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44878 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZDVKdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SOCCaSVQT5N1Q3z7uHE112aLdNmoFuV/U7tkQmH3yZJmBcTu/e0vswUmplyK7fV1fm
         jzjt1+0xponJYb8FIl7chl8gM2v8R4GcNQBcKNN4zpC8gZr1VbrFFpokJi9NJ68ROj9D
         kUeIg5QSp2Dll1rMomd1BE+/Rd9O2/anNte6Q=
MIME-Version: 1.0
Date: Wed, 22 Apr 2009 12:33:03 +0200
Message-ID: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
Subject: regression IWl3945 - doesn't work with recent 2.6.30-rcX
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm checking whether -rcX kernel could be usable on my
T61/4GB/C2D/x86_64 - but wireless seems to be still out of
functionality:
I'm getting lots of weird trace-back messages and it looks like
iwl3945 is not working at all.
(attached messages from fresh build of -rc3 - but it never worked even in -rc1)

I have no microcode errors with 2.6.29 and wifi works without problems

CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
CONFIG_IWLWIFI_DEBUG=y
# CONFIG_IWLAGN is not set
CONFIG_IWL3945=m
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y



Linux version 2.6.30-rc3 (kabi@dhcp-0-185.brq.redhat.com) (gcc version
4.4.0 20090414 (Red Hat 4.4.0-0.34) (GCC) ) #53 SMP Wed Apr 22
11:52:34 CEST 2009
Command line: ro root=/dev/sda5 selinux=0 no_console_suspend
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver
for Linux, 1.2.26kds
iwl3945: Copyright(c) 2003-2009 Intel Corporation
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: setting latency timer to 64
iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
iwl3945 0000:03:00.0: irq 31 for MSI/MSI-X
phy0: Selected rate control algorithm 'iwl-3945-rs'
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
	(5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
	(5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: power state changed by ACPI to D0
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:02.0: irq 32 for MSI/MSI-X
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as
/devices/platform/i8042/serio1/serio2/input/input8
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
iwl3945 0000:03:00.0: loaded firmware version 15.28.2.8
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:0b:6b:2c:df:31 try 1
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
wlan0: direct probe to AP 00:0b:6b:2c:df:31 try 2
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1114
iwl_tx_cmd_complete+0x303/0x350 [iwlcore]()
Hardware name: 6464CTO
wrong command queue 0, sequence 0x0 readp=38 writep=38
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc rfcomm sco l2cap
autofs4 sunrpc ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb cryptomgr aead
pcompress crypto_blkcipher crypto_hash crypto_algapi iwl3945 iwlcore
btusb bluetooth snd_hda_codec_analog mac80211 snd_hda_intel
snd_hda_codec snd_seq_oss sdhci_pci snd_seq_midi_event psmouse usbhid
sdhci mmc_core snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_pcm snd_timer iTCO_wdt serio_raw lib80211 rtc_cmos rtc_core snd
evdev sr_mod iTCO_vendor_support thinkpad_acpi rfkill backlight
i2c_i801 i2c_core button nvram hid intel_agp ac soundcore
snd_page_alloc cfg80211 rtc_lib e1000e battery led_class cdrom
uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
Pid: 0, comm: swapper Not tainted 2.6.30-rc3 #53
Call Trace:
 <IRQ>  [<ffffffff802459df>] warn_slowpath+0xaf/0xf0
 [<ffffffffa0282383>] iwl_tx_cmd_complete+0x303/0x350 [iwlcore]
 [<ffffffff803c035e>] ? swiotlb_bounce+0x1e/0x40
 [<ffffffff803c03fb>] ? sync_single+0x7b/0x90
 [<ffffffff803c0676>] ? swiotlb_sync_single+0x66/0x80
 [<ffffffffa02b3b47>] iwl3945_irq_tasklet+0x527/0x11e0 [iwl3945]
 [<ffffffff8024b3d1>] tasklet_action+0xd1/0xe0
 [<ffffffff8024bb52>] __do_softirq+0xa2/0x1f0
 [<ffffffff8020d33c>] call_softirq+0x1c/0x50
 [<ffffffff8020e9a5>] do_softirq+0x75/0xc0
 [<ffffffff8024b785>] irq_exit+0x95/0xa0
 [<ffffffff8055f0cd>] do_IRQ+0x8d/0xf0
 [<ffffffff8020cb93>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80416815>] ? acpi_idle_enter_simple+0x13b/0x16d
 [<ffffffff80416812>] ? acpi_idle_enter_simple+0x138/0x16d
 [<ffffffff804b61d3>] ? cpuidle_idle_call+0xa3/0xf0
 [<ffffffff8020af0e>] ? cpu_idle+0x6e/0xc0
 [<ffffffff80545fed>] ? rest_init+0x6d/0x80
 [<ffffffff80768cbb>] ? start_kernel+0x36f/0x37b
 [<ffffffff80768315>] ? x86_64_start_reservations+0x125/0x129
 [<ffffffff807683fd>] ? x86_64_start_kernel+0xe4/0xeb
---[ end trace acaf8830c0b4af6c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1114
iwl_tx_cmd_complete+0x303/0x350 [iwlcore]()
Hardware name: 6464CTO
wrong command queue 0, sequence 0x0 readp=38 writep=38
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc rfcomm sco l2cap
autofs4 sunrpc ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb cryptomgr aead
pcompress crypto_blkcipher crypto_hash crypto_algapi iwl3945 iwlcore
btusb bluetooth snd_hda_codec_analog mac80211 snd_hda_intel
snd_hda_codec snd_seq_oss sdhci_pci snd_seq_midi_event psmouse usbhid
sdhci mmc_core snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_pcm snd_timer iTCO_wdt serio_raw lib80211 rtc_cmos rtc_core snd
evdev sr_mod iTCO_vendor_support thinkpad_acpi rfkill backlight
i2c_i801 i2c_core button nvram hid intel_agp ac soundcore
snd_page_alloc cfg80211 rtc_lib e1000e battery led_class cdrom
uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.30-rc3 #53
Call Trace:
 <IRQ>  [<ffffffff802459df>] warn_slowpath+0xaf/0xf0
 [<ffffffffa0282383>] iwl_tx_cmd_complete+0x303/0x350 [iwlcore]
 [<ffffffff803c035e>] ? swiotlb_bounce+0x1e/0x40
 [<ffffffff803c03fb>] ? sync_single+0x7b/0x90
 [<ffffffff803c0676>] ? swiotlb_sync_single+0x66/0x80
 [<ffffffffa02b3b47>] iwl3945_irq_tasklet+0x527/0x11e0 [iwl3945]
 [<ffffffff8024b3d1>] tasklet_action+0xd1/0xe0
 [<ffffffff8024bb52>] __do_softirq+0xa2/0x1f0
 [<ffffffff8020d33c>] call_softirq+0x1c/0x50
 [<ffffffff8020e9a5>] do_softirq+0x75/0xc0
 [<ffffffff8024b785>] irq_exit+0x95/0xa0
 [<ffffffff8055f0cd>] do_IRQ+0x8d/0xf0
 [<ffffffff8020cb93>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80416815>] ? acpi_idle_enter_simple+0x13b/0x16d
 [<ffffffff80416812>] ? acpi_idle_enter_simple+0x138/0x16d
 [<ffffffff804b61d3>] ? cpuidle_idle_call+0xa3/0xf0
 [<ffffffff8020af0e>] ? cpu_idle+0x6e/0xc0
 [<ffffffff80545fed>] ? rest_init+0x6d/0x80
 [<ffffffff80768cbb>] ? start_kernel+0x36f/0x37b
 [<ffffffff80768315>] ? x86_64_start_reservations+0x125/0x129
 [<ffffffff807683fd>] ? x86_64_start_kernel+0xe4/0xeb
---[ end trace acaf8830c0b4af6d ]---
iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
iwl3945 0000:03:00.0: Error Reply type 0x00000001 cmd UNKNOWN (0xFF)
seq 0xFFFF ser 0x00FF0000
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
wlan0: direct probe to AP 00:0b:6b:2c:df:31 try 3
wlan0: direct probe to AP 00:0b:6b:2c:df:31 timed out
virbr0: no IPv6 routers present
eth0: no IPv6 routers present
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
fuse init (API version 7.11)
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
after 500ms.
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD:
enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD:
enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD:
enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD:
enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD:
enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD:
enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD:
enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
iwl3945 0000:03:00.0: No space for Tx
iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD:
enqueue_hcmd failed: -28
