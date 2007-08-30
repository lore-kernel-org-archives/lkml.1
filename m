Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbXH3Ik3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbXH3Ik3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 04:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbXH3IkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 04:40:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:51979 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbXH3IkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 04:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=h9bpY1gb+5dlk3bbTS3tm6SLruCeFu22yXP/A+e8br2v+b5lArHHg1/kVhZujGUaN1IX96bRx+eVa70fwDEQzxKNM7txLecbitJA6fYtLZ0K/MKPEsemWCiZI7imfDB8OWMb/i+NS9XB+9wfwN0gxO7HHpD/ahCJi6zEH0MhTQk=
Message-ID: <6d4bc9fc0708300140g65486ec1l21374ebc75c3d6f@mail.gmail.com>
Date: Thu, 30 Aug 2007 10:40:15 +0200
From: "Maarten Maathuis" <madman2003@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.22.1-rt4] very strange oops in the kernel, which made the system very slow to respond
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone make sense of this?

I have not encountered something like this, nor do i know what this trace means.

Please CC me if you reply.

Sincerely,

Maarten Maathuis.

log snippet:

Aug 29 21:15:15 localhost Unable to handle kernel paging request at
ffff81003a2c6518 RIP:
Aug 29 21:15:15 localhost [<ffff81003a2c6518>]
Aug 29 21:15:15 localhost PGD 8063 PUD 9063 PMD 800000003a2001e3 PTE
cb7794f74fd27497
Aug 29 21:15:15 localhost Oops: 0011 [1] PREEMPT
Aug 29 21:15:15 localhost CPU 0
Aug 29 21:15:15 localhost Modules linked in: sch_sfq cls_fw sch_htb
ip6table_filter iptable_raw xt_comment xt_policy xt_multiport ipt_ULOG
ipt_TTL ipt_ttl ipt_TOS ipt_tos ipt_SAME ipt_REJECT ipt_REDIRECT
ipt_recent ipt_owner ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_iprange
ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp
nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 xt_tcpmss
xt_pkttype xt_NFQUEUE xt_NFLOG xt_MARK xt_mark xt_mac xt_limit
xt_length xt_helper xt_hashlimit ip6_tables xt_dccp xt_conntrack
xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat
nf_conntrack_ipv4 iptable_mangle iptable_filter ip_tables x_tables
nf_conntrack_ftp nf_conntrack nfnetlink it87 hwmon_vid i2c_isa
i2c_nforce2 ivtv cx25840 wm8775 tuner cx2341x tveeprom videodev
v4l2_common v4l1_compat nouveau drm snd_ice1724 snd_ice17xx_ak4xxx
snd_ac97_codec ac97_bus snd_ak4114 snd_pcm snd_page_alloc snd_pt2258
snd_i2c snd_ak4xxx_adda snd_mpu401_uart snd_rawmidi k8temp
Aug 29 21:15:15 localhost Pid: 12, comm: softirq-rcu/0 Not tainted
2.6.22.1-rt4 #1
Aug 29 21:15:15 localhost RIP: 0010:[<ffff81003a2c6518>]  [<ffff81003a2c6518>]
Aug 29 21:15:15 localhost RSP: 0000:ffff81003ffa9ed8  EFLAGS: 00010282
Aug 29 21:15:15 localhost RAX: 00000000fffffeff RBX: ffff810006803500
RCX: 000000000000027c
Aug 29 21:15:15 localhost RDX: ffff81003ffa0100 RSI: ffff810038160240
RDI: ffff81002d613c80
Aug 29 21:15:15 localhost RBP: ffff81002d613c80 R08: ffff81003ffa8000
R09: ffffffff807116e0
Aug 29 21:15:15 localhost R10: 0000000000000000 R11: 00000000007a1200
R12: 0000000000000100
Aug 29 21:15:15 localhost R13: ffffffffffffffff R14: ffffffff806a6be0
R15: 0000000000000000
Aug 29 21:15:15 localhost FS:  00002ba7c91da6f0(0000)
GS:ffffffff80676000(0000) knlGS:00000000f738d6d0
Aug 29 21:15:15 localhost CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug 29 21:15:15 localhost CR2: ffff81003a2c6518 CR3: 0000000018fce000
CR4: 00000000000006e0
Aug 29 21:15:15 localhost Process softirq-rcu/0 (pid: 12, threadinfo
ffff81003ffa8000, task ffff81003ffa0100)
Aug 29 21:15:15 localhost Stack:  ffffffff80251fed ffff81003ffa9ef0
00000000fffffeff ffffffff8070d9c0
Aug 29 21:15:15 localhost ffffffff8022e7ce ffffffff00000032
0000000000000000 ffffffff8070d9c0
Aug 29 21:15:15 localhost ffffffff8022e6b8 ffff81003ff83d00
ffffffff8023aae3 0000000000000000
Aug 29 21:15:15 localhost Call Trace:
Aug 29 21:15:15 localhost [<ffffffff80251fed>] rcu_process_callbacks+0x96/0xb1
Aug 29 21:15:15 localhost [<ffffffff8022e7ce>] ksoftirqd+0x116/0x1b0
Aug 29 21:15:15 localhost [<ffffffff8022e6b8>] ksoftirqd+0x0/0x1b0
Aug 29 21:15:15 localhost [<ffffffff8023aae3>] kthread+0x47/0x74
Aug 29 21:15:15 localhost [<ffffffff80209cc8>] child_rip+0xa/0x12
Aug 29 21:15:15 localhost [<ffffffff8023aa9c>] kthread+0x0/0x74
Aug 29 21:15:15 localhost [<ffffffff80209cbe>] child_rip+0x0/0x12
Aug 29 21:15:15 localhost
Aug 29 21:15:15 localhost ---------------------------
Aug 29 21:15:15 localhost | preempt count: 00000000 ]
Aug 29 21:15:15 localhost | 0-level deep critical section nesting:
Aug 29 21:15:15 localhost ----------------------------------------
Aug 29 21:15:15 localhost
Aug 29 21:15:15 localhost
Aug 29 21:15:15 localhost Code: 80 3c 61 2d 00 81 ff ff 00 ce b6 39 00
81 ff ff 28 65 2c 3a
Aug 29 21:15:15 localhost RIP  [<ffff81003a2c6518>]
Aug 29 21:15:15 localhost RSP <ffff81003ffa9ed8>
Aug 29 21:15:15 localhost CR2: ffff81003a2c6518
Aug 29 21:15:15 localhost BUG: sleeping function called from invalid
context softirq-rcu/0(12) at kernel/rtmutex.c:636
Aug 29 21:15:15 localhost in_atomic():0 [00000000], irqs_disabled():1
Aug 29 21:15:15 localhost
Aug 29 21:15:15 localhost Call Trace:
Aug 29 21:15:15 localhost [<ffffffff804d99a8>] __rt_spin_lock+0x27/0x47
Aug 29 21:15:15 localhost [<ffffffff80226863>] __wake_up+0x1c/0x63
Aug 29 21:15:15 localhost [<ffffffff804da2ec>] oops_end+0x15/0x54
Aug 29 21:15:15 localhost [<ffffffff804dbbdf>] do_page_fault+0x694/0x75f
Aug 29 21:15:15 localhost [<ffffffff80222e9d>] dequeue_task+0x16/0x24
Aug 29 21:15:15 localhost [<ffffffff804d9c91>] __switch_to+0x21/0x270
Aug 29 21:15:15 localhost [<ffffffff80222e79>] enqueue_task+0x16/0x24
Aug 29 21:15:15 localhost [<ffffffff8022386f>] activate_task+0x6f/0x8b
Aug 29 21:15:15 localhost [<ffffffff80225c50>] try_to_wake_up+0xea/0x114
Aug 29 21:15:15 localhost [<ffffffff804d9f5d>] error_exit+0x0/0x84
Aug 29 21:15:15 localhost [<ffffffff80251fed>] rcu_process_callbacks+0x96/0xb1
Aug 29 21:15:15 localhost [<ffffffff8022e7ce>] ksoftirqd+0x116/0x1b0
Aug 29 21:15:15 localhost [<ffffffff8022e6b8>] ksoftirqd+0x0/0x1b0
Aug 29 21:15:15 localhost [<ffffffff8023aae3>] kthread+0x47/0x74
Aug 29 21:15:15 localhost [<ffffffff80209cc8>] child_rip+0xa/0x12
Aug 29 21:15:15 localhost [<ffffffff8023aa9c>] kthread+0x0/0x74
Aug 29 21:15:15 localhost [<ffffffff80209cbe>] child_rip+0x0/0x12
Aug 29 21:15:15 localhost
Aug 29 21:15:15 localhost ---------------------------
Aug 29 21:15:15 localhost | preempt count: 00000000 ]
Aug 29 21:15:15 localhost | 0-level deep critical section nesting:
Aug 29 21:15:15 localhost ----------------------------------------
Aug 29 21:15:15 localhost
