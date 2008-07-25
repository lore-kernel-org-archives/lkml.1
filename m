Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYGYCk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYGYCk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYGYCkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:40:11 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:58005 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751774AbYGYCkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:40:09 -0400
Date: Thu, 24 Jul 2008 22:40:07 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: linux-kernel@vger.kernel.org
Subject: ath9k git vs tip git
Message-ID: <20080725024007.GA940@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   I've been able to create a patch from the ath9k git that
applies to the current tip git and appears to build usable
ath9k drivers. Booting with...

alias ath0 ath9k
alias wifi0 ath9k

gives the following messages in dmesg...

ath9k: 0.1
ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
phy0: Selected rate control algorithm 'ath9k_rate_control'
udev: renamed network interface wlan0 to ath0
device-mapper: multipath: version 1.0.5 loaded
ADDRCONF(NETDEV_UP): ath0: link is not ready
ath9k/1009 is trying to acquire lock:
3 locks held by ath9k/1009:
Pid: 1009, comm: ath9k Not tainted 2.6.27-0.159.rc0.git11.fc9.x86_64 #1
 [<ffffffffa010542a>] ? ath_set_channel+0x20d/0x225 [ath9k]
Modules linked in: bridge stp bnep rfcomm l2cap bluetooth fuse sunrpc ipt_REJECT
 nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_i
pv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables cpufreq_ondemand a
cpi_cpufreq freq_table dm_mirror dm_log dm_multipath dm_mod ipv6 snd_seq_dummy s
nd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss s
nd_mixer_oss snd_pcm joydev arc4 snd_timer i2c_i801 firewire_ohci sr_mod snd_pag
e_alloc i2c_core ecb iTCO_wdt iTCO_vendor_support pcspkr firewire_core cdrom snd
_hwdep crypto_blkcipher snd crc_itu_t ath9k video mac80211 cfg80211 battery soun
dcore sky2 output appletouch ac pata_acpi ata_generic ata_piix ext3 jbd mbcache 
uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 1009, comm: ath9k Not tainted 2.6.27-0.159.rc0.git11.fc9.x86_64 #1
 [<ffffffff810407d4>] warn_on_slowpath+0x65/0x8c
ath0: authenticate with AP 00:13:f7:05:e8:92
ath0: authenticated
ath0: associate with AP 00:13:f7:05:e8:92
ath0: associate with AP 00:13:f7:05:e8:92
ath0: associate with AP 00:13:f7:05:e8:92
ath0: association with AP 00:13:f7:05:e8:92 timed out
Modules linked in: bridge stp bnep rfcomm l2cap bluetooth fuse sunrpc ipt_REJECT
 nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_i
pv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables cpufreq_ondemand a
cpi_cpufreq freq_table dm_mirror dm_log dm_multipath dm_mod ipv6 snd_seq_dummy s
nd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss s
nd_mixer_oss snd_pcm joydev arc4 snd_timer i2c_i801 firewire_ohci sr_mod snd_pag
e_alloc i2c_core ecb iTCO_wdt iTCO_vendor_support pcspkr firewire_core cdrom snd
_hwdep crypto_blkcipher snd crc_itu_t ath9k video mac80211 cfg80211 battery soun
dcore sky2 output appletouch ac pata_acpi ata_generic ata_piix ext3 jbd mbcache 
uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
 [<ffffffff8100c2da>] system_call_fastpath+0x16/0x1b
Modules linked in: bridge stp bnep rfcomm l2cap bluetooth fuse sunrpc ipt_REJECT
 nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_i
pv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables cpufreq_ondemand a
cpi_cpufreq freq_table dm_mirror dm_log dm_multipath dm_mod ipv6 snd_seq_dummy s
nd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss s
nd_mixer_oss snd_pcm joydev arc4 snd_timer i2c_i801 firewire_ohci sr_mod snd_pag
e_alloc i2c_core ecb iTCO_wdt iTCO_vendor_support pcspkr firewire_core cdrom snd
_hwdep crypto_blkcipher snd crc_itu_t ath9k video mac80211 cfg80211 battery soun
dcore sky2 output appletouch ac pata_acpi ata_generic ata_piix ext3 jbd mbcache 
uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
 [<ffffffff8100c2da>] system_call_fastpath+0x16/0x1b
ath0: authenticate with AP 00:18:f8:d7:ab:80
ath0: authenticated
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: RX AssocResp from 00:18:f8:d7:ab:80 (capab=0x431 status=0 aid=1)
ath0: associated
ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
ath0: deauthenticated
ath0: authenticate with AP 00:18:f8:d7:ab:80
ath0: authenticated
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: no IPv6 routers present
ath0: association with AP 00:18:f8:d7:ab:80 timed out
ath0: authenticate with AP 00:18:f8:d7:ab:80
ath0: authenticate with AP 00:18:f8:d7:ab:80
ath0: authenticated
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: association with AP 00:18:f8:d7:ab:80 timed out
ath0: authenticate with AP 00:18:f8:d7:ab:80
ath0: authenticate with AP 00:18:f8:d7:ab:80
ath0: authenticated
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: associate with AP 00:18:f8:d7:ab:80
ath0: association with AP 00:18:f8:d7:ab:80 timed out

However the NetworkManager seems unable to get an address
from the AP. I assumed I should add...

options ath9k autocreate=sta

to modprobe.conf as well. However this produces the errors
about an unknown option. What is the proper way to set
the ath9k driver in sta mode? Or does tip not contain enough
patches from the mywireless-testing git?
                  Jack



