Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbXE3Uer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbXE3Uer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXE3Ueh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:34:37 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:54301 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbXE3Ueg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:34:36 -0400
Date: Wed, 30 May 2007 22:34:34 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: power@bughost.org, linux-kernel@vger.kernel.org
Subject: [2.6.21.1] running powertop 1.5 for 10 seconds causes a kernel
	panic
Message-ID: <20070530203434.GB9806@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu May 31 22:26:34 CEST 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

P4 with HT and 2GB of ram
desktop (altough acting as a sever with 300 processes fighting for cpu
time)

[350598.081548] audit(1180545318.054:16): dev=eth1 prom=0 old_prom=256 auid=4294967295
[361753.921304] BUG: unable to handle kernel paging request at virtual address b9d0458f
[361753.921404]  printing eip:
[361753.921446] c10388d8
[361753.921487] *pde = 00000000
[361753.921530] Oops: 0000 [#1]
[361753.921571] SMP
[361753.921682] Modules linked in: tuner tvaudio bttv video_buf ir_common i2c_algo_bit btcx_risc tveeprom nfs pwc wcfxo pl2303 zaptel usbserial plusb usbnet w83627hf hwmon_vid snd_pcm_oss eeprom snd_mixer_oss i2c_isa i2c_core snd_intel8x0 snd_ac97_codec sd_mod snd_pcm scsi_mod snd_timer snd ide_cd soundcore cdrom snd_page_alloc ac97_bus parport_pc parport microcode firmware_class nfsd exportfs lockd sunrpc netconsole ipt_owner ip6table_filter ip6_tables ipv6 ipt_recent xt_limit xt_state act_police sch_ingress cls_u32 sch_sfq sch_cbq ipt_REJECT ipt_MASQUERADE ipt_TOS xt_tcpudp iptable_mangle iptable_filter rtl8150 e1000 3c59x mii iptable_nat ip_tables nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink x_tables capability commoncap ppp_deflate zlib_deflate zlib_inflate ppp_async crc_ccitt ppp_generic slip slhc genrtc rd
[361753.924725] CPU:    0
[361753.924726] EIP:    0060:[<c10388d8>]    Not tainted VLI
[361753.924728] EFLAGS: 00010046   (2.6.21.1test2 #4)
[361753.924860] EIP is at match_entries+0xb/0x38
[361753.924904] eax: c25f1a80   ebx: 00000000   ecx: b9d0458b   edx: ddc87ec8
[361753.924950] esi: ddc87ec8   edi: c25f19a0   ebp: ddc87ea0   esp: ddc87e9c
[361753.924996] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[361753.925043] Process einstein_S5R2_4 (pid: 21004, ti=ddc87000 task=f75780b0 task.ti=ddc87000)
[361753.925092] Stack: b9d0458b ddc87ec0 c1038941 c12109d1 c12ffe90 c25f1ab0 00000096 c25f1b04
[361753.925451]        c25f19a0 ddc87f50 c1038a1c c1494d70 c25f1a80 c103841c c1038620 00000000
[361753.925804]        00000000 45d6f5f0 00000001 f75785f8 c13daf40 00000001 f75785f8 c13f8c70
[361753.926152] Call Trace:
[361753.926230]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[361753.926312]  [<c1004e0a>] show_stack_log_lvl+0x8d/0xaa
[361753.926394]  [<c1005044>] show_registers+0x1cd/0x2cb
[361753.926475]  [<c10052a1>] die+0x11b/0x227
[361753.926554]  [<c1212ad7>] do_page_fault+0x319/0x57a
[361753.926636]  [<c12110b4>] error_code+0x7c/0x84
[361753.926716]  [<c1038941>] tstat_lookup+0x3c/0xc9
[361753.926794]  [<c1038a1c>] timer_stats_update_stats+0x4e/0x6f
[361753.926874]  [<c1033d5d>] hrtimer_interrupt+0x184/0x1e3
[361753.926955]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[361753.927036]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[361753.927118]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[361753.927197]  =======================
[361753.927239] Code: 3d ff 03 00 00 89 e5 77 13 89 c2 83 c0 01 c1 e2 07 a3 98 2c 37 c1 81 c2 00 2d 37 c1 89 d0 5d c3 55 89 c1 8b 42 04 89 e5 53 31 db <39> 41 04 74 05 89 d8 5b 5d c3 8b 42 08 39 41 08 75 f3 8b 42 0c
[361753.929496] EIP: [<c10388d8>] match_entries+0xb/0x38 SS:ESP 0068:ddc87e9c
[361753.929619] Kernel panic - not syncing: Fatal exception in interrupt
[361753.929669] BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
[361753.929715]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[361753.929795]  [<c1004d7b>] show_trace+0x12/0x14
[361753.929873]  [<c1004e75>] dump_stack+0x16/0x18
[361753.930148]  [<c100df63>] smp_call_function+0x10f/0x114
[361753.930229]  [<c100dfb9>] smp_send_stop+0x1e/0x31
[361753.930309]  [<c101ca83>] panic+0x50/0xf5
[361753.930389]  [<c100539e>] die+0x218/0x227
[361753.930472]  [<c1212ad7>] do_page_fault+0x319/0x57a
[361753.930558]  [<c12110b4>] error_code+0x7c/0x84
[361753.930642]  [<c1038941>] tstat_lookup+0x3c/0xc9
[361753.930724]  [<c1038a1c>] timer_stats_update_stats+0x4e/0x6f
[361753.930807]  [<c1033d5d>] hrtimer_interrupt+0x184/0x1e3
[361753.930890]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[361753.930973]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[361753.931055]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[361753.931139]  =======================


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
