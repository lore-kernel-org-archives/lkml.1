Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbYLWEiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbYLWEiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYLWEiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:38:05 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:33551 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbYLWEiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=tRgxSF4edPhKRVxiA2JwPE55Z7GwYf0JO1DtQAhNRyrBh8/GcIivaLKLq0gotYFtJH
         FSrvHwd3XeRoQ2hNPj+i0EOYF7Ntr9BK4foV3FfqSY4kgsLUKs+L5WrRJs7zj4DaKBC0
         bVIAvyNrEMImHvblLbiahaL6n/gQwURZKM+no=
Message-ID: <dd18b0c30812222038h64f8bc87l9f5a5744dd3f1ab4@mail.gmail.com>
Date: Mon, 22 Dec 2008 20:38:00 -0800
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: WARNING: at drivers/net/wireless/b43/xmit.c:625 b43_rx+0x3c4/0x462()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not too sure what this is telling me
was running a DVD then a few moments later this
appeared:

[ 2343.251192] end_request: I/O error, dev sr0, sector 8388008
[ 2343.251202] Buffer I/O error on device sr0, logical block 1048501
[ 2343.274587] end_request: I/O error, dev sr0, sector 8388008
[ 2343.274595] Buffer I/O error on device sr0, logical block 1048501
[ 4906.712403] ------------[ cut here ]------------
[ 4906.712410] WARNING: at drivers/net/wireless/b43/xmit.c:625
b43_rx+0x3c4/0x462()
[ 4906.712413] Modules linked in: i915 bnep rfcomm sco l2cap bluetooth
container fan sbs sbshc i810 drm ipmi_watchdog ipmi_msghandler uinput
ieee80211_crypt_tkip ieee80211 ieee80211_crypt arpt_mangle
arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables eeprom
cpufreq_powersave cpufreq_performance cpufreq_ondemand
cpufreq_conservative joydev snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm snd_timer piix ide_pci_generic psmouse snd_page_alloc
pata_acpi video thermal intel_agp button battery ac agpgart processor
evdev
[ 4906.712482] Pid: 741, comm: b43 Not tainted 2.6.28-rc9-00039-g3d44cc3 #3
[ 4906.712486] Call Trace:
[ 4906.712494]  [<c03fb559>] ? printk+0xf/0x16
[ 4906.712502]  [<c01269bf>] warn_on_slowpath+0x41/0x63
[ 4906.712510]  [<c038d20c>] ? ip_local_deliver_finish+0xd0/0x181
[ 4906.712515]  [<c038d314>] ? ip_local_deliver+0x57/0x60
[ 4906.712520]  [<c038cf0c>] ? ip_rcv_finish+0x27c/0x292
[ 4906.712525]  [<c038d112>] ? ip_rcv+0x1f0/0x21a
[ 4906.712531]  [<c0119efc>] ? update_curr+0xa3/0x17e
[ 4906.712538]  [<c017660a>] ? check_object+0x115/0x196
[ 4906.712542]  [<c02a971b>] b43_rx+0x3c4/0x462
[ 4906.712548]  [<c02afa30>] b43_pio_rx_work+0x2a7/0x2fe
[ 4906.712556]  [<c0133c9e>] run_workqueue+0x79/0xf3
[ 4906.712560]  [<c02af789>] ? b43_pio_rx_work+0x0/0x2fe
[ 4906.712565]  [<c0133dce>] worker_thread+0xb6/0xc2
[ 4906.712571]  [<c0136beb>] ? autoremove_wake_function+0x0/0x33
[ 4906.712577]  [<c0133d18>] ? worker_thread+0x0/0xc2
[ 4906.712581]  [<c0136975>] kthread+0x3b/0x61
[ 4906.712585]  [<c013693a>] ? kthread+0x0/0x61
[ 4906.712592]  [<c0103daf>] kernel_thread_helper+0x7/0x10
[ 4906.712595] ---[ end trace 3423365af0a1ae2a ]---
[ 4906.712639] ------------[ cut here ]------------
[ 4906.712642] WARNING: at net/mac80211/rx.c:2201 __ieee80211_rx+0x4c/0x4c1()
[ 4906.712645] Modules linked in: i915 bnep rfcomm sco l2cap bluetooth
container fan sbs sbshc i810 drm ipmi_watchdog ipmi_msghandler uinput
ieee80211_crypt_tkip ieee80211 ieee80211_crypt arpt_mangle
arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables eeprom
cpufreq_powersave cpufreq_performance cpufreq_ondemand
cpufreq_conservative joydev snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm snd_timer piix ide_pci_generic psmouse snd_page_alloc
pata_acpi video thermal intel_agp button battery ac agpgart processor
evdev
[ 4906.712705] Pid: 741, comm: b43 Tainted: G        W
2.6.28-rc9-00039-g3d44cc3 #3
[ 4906.712708] Call Trace:
[ 4906.712712]  [<c03fb559>] ? printk+0xf/0x16
[ 4906.712717]  [<c01269bf>] warn_on_slowpath+0x41/0x63
[ 4906.712722]  [<c03fb559>] ? printk+0xf/0x16
[ 4906.712727]  [<c012690f>] ? print_oops_end_marker+0x1e/0x23
[ 4906.712731]  [<c01269c4>] ? warn_on_slowpath+0x46/0x63
[ 4906.712736]  [<c0119efc>] ? update_curr+0xa3/0x17e
[ 4906.712742]  [<c03e3973>] __ieee80211_rx+0x4c/0x4c1
[ 4906.712749]  [<c0227a84>] ? _raw_spin_lock+0x53/0xf7
[ 4906.712754]  [<c0227a84>] ? _raw_spin_lock+0x53/0xf7
[ 4906.712761]  [<c036999f>] ? skb_dequeue+0x45/0x4c
[ 4906.712766]  [<c03d5df3>] ieee80211_tasklet_handler+0x64/0xdc
[ 4906.712773]  [<c012a509>] tasklet_action+0x75/0xd6
[ 4906.712778]  [<c012abcc>] __do_softirq+0x8d/0x133
[ 4906.712783]  [<c012acba>] do_softirq+0x48/0x57
[ 4906.712788]  [<c012adc9>] irq_exit+0x38/0x6d
[ 4906.712792]  [<c0104c42>] do_IRQ+0x96/0xac
[ 4906.712797]  [<c0103b73>] common_interrupt+0x23/0x28
[ 4906.712802]  [<c03fda4c>] ? _spin_unlock_irq+0xa/0x14
[ 4906.712807]  [<c02afa6d>] b43_pio_rx_work+0x2e4/0x2fe
[ 4906.712813]  [<c0133c9e>] run_workqueue+0x79/0xf3
[ 4906.712818]  [<c02af789>] ? b43_pio_rx_work+0x0/0x2fe
[ 4906.712823]  [<c0133dce>] worker_thread+0xb6/0xc2
[ 4906.712828]  [<c0136beb>] ? autoremove_wake_function+0x0/0x33
[ 4906.712833]  [<c0133d18>] ? worker_thread+0x0/0xc2
[ 4906.712837]  [<c0136975>] kthread+0x3b/0x61
[ 4906.712841]  [<c013693a>] ? kthread+0x0/0x61
[ 4906.712846]  [<c0103daf>] kernel_thread_helper+0x7/0x10
[ 4906.712849] ---[ end trace 3423365af0a1ae2a ]---
[ 5382.508113] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 5382.508129] ata1.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
[ 5382.508131]          cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
[ 5382.508133]          res 51/20:03:00:00:00/00:00:00:00:00/b0 Emask
0x1 (device error)
[ 5382.508138] ata1.01: status: { DRDY ERR }

System is a Dell inspiron 1200
wireless card is a dell 1350
I can attach full dmesg if need be.

regards;

-- 
Justin P. Mattock
