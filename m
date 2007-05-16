Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbXEPQZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbXEPQZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPQY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:24:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:47019 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXEPQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=mSc201VyTOVN+Mml0d8z/KNyYy5mP2dWGdHVfu6iUtCSdi7BuD0d50HrHEvvlJ2jhQnYakHW/0sSrYbqlLSoCgUWzuXGveM/6hb2Lb3f155Xsizzvjnb+CccMdPJ4Fw6kJiwJe3WBG9ll9n5lubBYNZ0qYKZKEhXfr5muOhdJ20=
Message-ID: <464B304C.5040104@googlemail.com>
Date: Wed, 16 May 2007 18:24:44 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> 

Almost every time when I try to run this script I hit a bug. I'm wondering why...
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc1-mm1/test_mount_fs.sh

[ 6666.713016] kernel BUG at /home/devel/linux-mm/include/linux/mm.h:288!
[ 6666.719690] invalid opcode: 0000 [#1]
[ 6666.723397] PREEMPT SMP
[ 6666.725999] Modules linked in: xfs loop pktgen ipt_MASQUERADE iptable_nat nf_nat autofs4 af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer snd soundcore intel_agp agpgart snd_page_alloc i2c_i801 ide_cd cdrom rtc unix
[ 6666.776026] CPU:    0
[ 6666.776027] EIP:    0060:[<c01693ec>]    Not tainted VLI
[ 6666.776028] EFLAGS: 00010202   (2.6.22-rc1-mm1 #3)
[ 6666.788519] EIP is at put_page+0x44/0xee
[ 6666.792491] eax: 00000001   ebx: c549f728   ecx: c04b27e0   edx: 00000001
[ 6666.799345] esi: 00000000   edi: 00000080   ebp: d067e9e0   esp: d067e9c8
[ 6666.806208] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[ 6666.812104] Process mount (pid: 9419, ti=d067e000 task=d00a4070 task.ti=d067e000)
[ 6666.819486] Stack: d8980180 00000080 d067e9f0 d8980180 00000000 00000080 d067e9f0 fdc8eda3
[ 6666.828103]        fffffffc d8980180 d067ea20 fdc8f7ff fdc9b425 fdc96e5c 00080000 00000000
[ 6666.836635]        c549dfd0 00000200 ffffffff cd44b8e0 00002160 cd44b8e0 d067ea30 fdc78937
[ 6666.845253] Call Trace:
[ 6666.847939]  [<fdc8eda3>] xfs_buf_free+0x41/0x61 [xfs]
[ 6666.853247]  [<fdc8f7ff>] xfs_buf_get_noaddr+0x10c/0x118 [xfs]
[ 6666.859231]  [<fdc78937>] xlog_get_bp+0x65/0x69 [xfs]
[ 6666.864412]  [<fdc79e87>] xlog_write_log_records+0x73/0x20d [xfs]
[ 6666.870654]  [<fdc7a174>] xlog_clear_stale_blocks+0x153/0x15b [xfs]
[ 6666.877075]  [<fdc7a546>] xlog_find_tail+0x3ca/0x43d [xfs]
[ 6666.882695]  [<fdc7c241>] xlog_recover+0x14/0x9b [xfs]
[ 6666.887968]  [<fdc75d13>] xfs_log_mount+0xad/0xf1 [xfs]
[ 6666.893332]  [<fdc7ec47>] xfs_mountfs+0x959/0xc4a [xfs]
[ 6666.898689]  [<fdc714f6>] xfs_ioinit+0x26/0x2c [xfs]
[ 6666.903789]  [<fdc85692>] xfs_mount+0x2e5/0x358 [xfs]
[ 6666.908988]  [<fdc95b66>] vfs_mount+0x1a/0x1e [xfs]
[ 6666.914035]  [<fdc95a20>] xfs_fs_fill_super+0x76/0x1a2 [xfs]
[ 6666.919868]  [<c018597f>] get_sb_bdev+0x105/0x143
[ 6666.924652]  [<fdc94d57>] xfs_fs_get_sb+0x21/0x27 [xfs]
[ 6666.930033]  [<c0185501>] vfs_kern_mount+0x81/0xf1
[ 6666.934887]  [<c0199b51>] do_mount+0x716/0x80d
[ 6666.939390]  [<c0199cc8>] sys_mount+0x80/0xb5
[ 6666.943824]  [<c01041d0>] syscall_call+0x7/0xb
[ 6666.948338]  [<b7fbe410>] 0xb7fbe410
[ 6666.951983]  =======================
[ 6666.955606] INFO: lockdep is turned off.
[ 6666.959633] Code: 3f 19 0b 00 85 c0 74 0c 89 d8 e8 1a fa ff ff e9 b9 00 00 00 31 d2 83 7b 04 00 0f 94 c2 b8 e0 27 4b c0 e8 1c 19 0b 00 85 c0 74 04 <0f> 0b eb fe 83 7b 04 00 75 11 c7 04 24 be 60 3f c0 e8 91 c6 fb
[ 6666.979608] EIP: [<c01693ec>] put_page+0x44/0xee SS:ESP 0068:d067e9c8
[ 6667.271984] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.331795] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.391521] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.449690] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.510147] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.568178] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.629555] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.683491] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.738154] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.799303] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.870552] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.926975] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6667.978262] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.032587] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.149829] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.299368] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.363383] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.464227] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.610582] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.660383] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.712897] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.764799] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.814554] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.870878] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.923868] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6668.974482] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.027816] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.266933] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.327291] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.378235] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.428371] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.536891] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.602642] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.656877] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.710353] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.762052] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.810963] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.864179] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.917908] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6669.967097] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6670.024015] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6670.074487] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6670.240395] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6670.350305] XFS: Filesystem loop1 has duplicate UUID - can't mount
[ 6670.458773] XFS: Filesystem loop1 has duplicate UUID - can't mount

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc1-mm1/mm-dmesg2
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc1-mm1/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
