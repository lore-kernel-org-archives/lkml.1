Return-Path: <linux-kernel-owner+w=401wt.eu-S1750851AbXCESEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851AbXCESEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXCESEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:04:31 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:17587 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbXCESEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=QdS5Fj394GNeJJFazgxgWPX9GX8nbQ+sO59g1wNVAnAh6T27hIbWP4z0Nrd18h9udPdHIZo15xl6NLcGAnO+FS7tUSqNTaGZ/dihESD0+Rq4aMJVtrI81u5GCYXZWw5O+kBEgKGrTd6LZ7co2J/hlb8/Iks9IGhANMGESCJGx1A=
Message-ID: <45EC5B48.3050407@googlemail.com>
Date: Mon, 05 Mar 2007 19:02:48 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
In-Reply-To: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-03-05-02-22.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-05-02-22.tar.gz
> 
> It contains the following patches against 2.6.21-rc2:

This might be helpful in tracking down this bug

http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#0889
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165

SysRq : Terminate All Tasks
SysRq : Kill All Tasks
SysRq : SAK
------------[ cut here ]------------
kernel BUG at kernel/workqueue.c:156!
invalid opcode: 0000 [#1]
PREEMPT SMP 
last sysfs file: devices/platform/i2c-9191/9191-0290/temp2_input
Modules linked in: isofs nls_base zlib_inflate ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer intel_agp snd agpgart soundcore skge i2c_i801 snd_page_alloc 8139too sk98lin mii ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c0132ddb>]    Not tainted VLI
EFLAGS: 00010002   (2.6.21-rc2-mm1 #2)
EIP is at queue_work+0x2f/0x8f
eax: 00000001   ebx: c07d783c   ecx: c042f96c   edx: 00000001
esi: c781a7f8   edi: 0000006b   ebp: d097be24   esp: d097be1c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process firefox-bin (pid: 12655, ti=d097a000 task=cec52ae0 task.ti=d097a000)
Stack: c044ea50 00000001 d097be2c c0132e4a d097be34 c0261e91 d097be5c c0261d8f 
       c03f0f61 c03f2f32 cc3686ec 00000008 00000082 00000025 00000000 00000025 
       d097be64 c0261f6a d097be90 c025cbb6 0000157f 007bb2e1 cc3686ec 01010036 
Call Trace:
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c0105308>] show_stack_log_lvl+0x9d/0xac
 [<c0105504>] show_registers+0x1ed/0x34c
 [<c0105780>] die+0x11d/0x234
 [<c0105921>] do_trap+0x8a/0xa3
 [<c010620a>] do_invalid_op+0x97/0xa1
 [<c033b764>] error_code+0x7c/0x84
 [<c0132e4a>] schedule_work+0xf/0x11
 [<c0261e91>] sysrq_handle_SAK+0x14/0x16
 [<c0261d8f>] __handle_sysrq+0x8c/0x109
 [<c0261f6a>] handle_sysrq+0x1f/0x21
 [<c025cbb6>] kbd_event+0x2d8/0x4ee
 [<c02bd926>] input_event+0x420/0x442
 [<c02c0ff9>] atkbd_interrupt+0x44d/0x518
 [<c02ba6b2>] serio_interrupt+0x49/0x7f
 [<c02bb4ec>] i8042_interrupt+0x226/0x239
 [<c0155886>] handle_IRQ_event+0x1a/0x46
 [<c015699e>] handle_edge_irq+0x10a/0x14e
 [<c0106c22>] do_IRQ+0xa3/0xbd
 [<c0104c52>] common_interrupt+0x2e/0x34
 =======================
Code: 53 89 c6 89 d3 f0 0f ba 2a 00 19 c0 31 d2 85 c0 75 73 8d 43 04 31 d2 39 43 04 0f 95 c2 b8 6c f9 42 c0 e8 b1 e4 0d 00 85 c0 74 04 <0f> 0b eb fe b8 01 00 00 00 e8 73 bd fe ff e8 da db 0d 00 89 c2 
EIP: [<c0132ddb>] queue_work+0x2f/0x8f SS:ESP 0068:d097be1c

l *0xc0132ddb
0xc0132ddb is in queue_work (kernel/workqueue.c:156).
151     int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
152     {
153             int ret = 0;
154
155             if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
156                     BUG_ON(!list_empty(&work->entry));
157                     __queue_work(wq_per_cpu(wq, get_cpu()), work);
158                     put_cpu();
159                     ret = 1;
160             }

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-05-02-22/mm-config

serial console log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-05-02-22/mm_snaps2.txt

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
