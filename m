Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYG1HLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYG1HLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 03:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYG1HKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 03:10:55 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:26346 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYG1HKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 03:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=QfNqxM0dnjEC3Q6J+4AW/bue/sIwBe7641256vecO1993F7UvgNnOYHP1bmPvNFr/p
         +S8eW6wiC8O0tnkcTBKNoenqFO90AbWhqN+0/LHwIzrJMBaO3j1YNsMMTwdkhKfIVqEe
         6HkVhqk7YfXW95mroBynz5CyT1Nc0LJ3k0b8k=
Message-ID: <dd18b0c30807280010h34002232wb53b7a154d9853fc@mail.gmail.com>
Date: Mon, 28 Jul 2008 00:10:46 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: NETDEV WATCHDOG: wifi0: transmit timed out
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should'nt be posting this, due to
having  tainted modules(madwifi), but
I figured I might as well:(below)

[ 5000.986044] NETDEV WATCHDOG: wifi0: transmit timed out
[ 5000.991959] ------------[ cut here ]------------
[ 5000.991964] WARNING: at net/sched/sch_generic.c:222 dev_watchdog+0x95/0xe7()
[ 5000.991968] Modules linked in: hci_usb cpufreq_ondemand
cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth
container battery fan ipmi_watchdog ipmi_msghandler isight_firmware
uinput wlan_tkip ieee80211_crypt_tkip ieee80211 ieee80211_crypt
arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom
acpi_cpufreq applesmc joydev appletouch uvcvideo wlan_scan_sta
ath_rate_sample ath_pci firewire_ohci wlan firewire_core fglrx(P)
snd_hda_intel ath_hal(P) snd_pcm snd_timer agpgart snd_page_alloc
snd_hwdep ohci1394 evdev thermal ath5k ieee1394 ehci_hcd uhci_hcd
pata_acpi video processor ac button sbshc
[ 5000.992067] Pid: 0, comm: swapper Tainted: P          2.6.26 #5
[ 5000.992075]  [<c0123487>] warn_on_slowpath+0x41/0x6b
[ 5000.992113]  [<f8de1cfc>] ? ath_reset+0x31c/0x372 [ath_pci]
[ 5000.992139]  [<f8de2298>] ? ath_tx_timeout+0xbc/0xd5 [ath_pci]
[ 5000.992156]  [<c0123e0e>] ? printk+0x15/0x17
[ 5000.992168]  [<c031d40a>] dev_watchdog+0x95/0xe7
[ 5000.992177]  [<c012ab73>] run_timer_softirq+0x11e/0x180
[ 5000.992185]  [<c031d375>] ? dev_watchdog+0x0/0xe7
[ 5000.992193]  [<c031d375>] ? dev_watchdog+0x0/0xe7
[ 5000.992204]  [<c01275c4>] __do_softirq+0x6d/0xdf
[ 5000.992215]  [<c012767e>] do_softirq+0x48/0x57
[ 5000.992223]  [<c012791e>] irq_exit+0x38/0x6b
[ 5000.992230]  [<c0110627>] smp_apic_timer_interrupt+0x6e/0x7f
[ 5000.992240]  [<c0103a38>] apic_timer_interrupt+0x28/0x30
[ 5000.992252]  [<c013007b>] ? sys_getpriority+0x153/0x190
[ 5000.992263]  [<c03983fe>] ? _spin_unlock_irqrestore+0xf/0x1a
[ 5000.992274]  [<c013b3a2>] tick_broadcast_oneshot_control+0xdd/0xe3
[ 5000.992286]  [<c013add8>] tick_notify+0x1cd/0x2e5
[ 5000.992295]  [<c024f822>] ? acpi_hw_low_level_write+0x8e/0xc1
[ 5000.992308]  [<c039a089>] notifier_call_chain+0x2b/0x4a
[ 5000.992320]  [<c0136d71>] __raw_notifier_call_chain+0xe/0x10
[ 5000.992329]  [<c0136d7f>] raw_notifier_call_chain+0xc/0xe
[ 5000.992337]  [<c013a826>] clockevents_do_notify+0x11/0x13
[ 5000.992345]  [<c013a844>] clockevents_notify+0x1c/0x5c
[ 5000.992354]  [<f8838b56>] acpi_state_timer_broadcast+0x31/0x34 [processor]
[ 5000.992371]  [<f88397b3>] acpi_idle_enter_bm+0x2cf/0x322 [processor]
[ 5000.992389]  [<c02e896b>] cpuidle_idle_call+0x5e/0x8b
[ 5000.992399]  [<c0101c04>] cpu_idle+0xc4/0xe4
[ 5000.992406]  [<c03946ae>] start_secondary+0x168/0x16d
[ 5000.992426]  =======================
[ 5000.992430] ---[ end trace 83ab3ac068df9439 ]---


-- 
Justin P. Mattock
