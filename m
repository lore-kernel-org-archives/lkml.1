Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbXKFIuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbXKFIuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXKFIuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:50:09 -0500
Received: from hempcity.net ([81.171.100.190]:60967 "EHLO hempcity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbXKFIuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:50:06 -0500
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 03:50:06 EST
Message-ID: <35032.212.120.65.207.1194338096.squirrel@webmail.coolzero.info>
Date: Tue, 6 Nov 2007 09:34:56 +0100 (CET)
Subject: Oom-killer error.
From: "Jim van Wel" <jim@coolzero.info>
To: linux-kernel@vger.kernel.org
Reply-To: jim@coolzero.info
User-Agent: SquirrelMail/1.4.8-4.0.1.el4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I have a strange problem with like 10-15 servers right now.
We have here all HP DL380-G5 servers with kernel 2.6.22.6. System all
works normall. But after a uptime of like 15 a 25 days, we get these
messages, and the servers is just crashed.

[1791648.015312] exim4 invoked oom-killer: gfp_mask=0xd0, order=0,
oomkilladj=0
[1791648.022415]  [<c015c2dd>] out_of_memory+0x18d/0x1d0
[1791648.027537]  [<c015d955>] __alloc_pages+0x315/0x340
[1791648.032657]  [<c017640d>] cache_alloc_refill+0x2ed/0x520
[1791648.038215]  [<c0176114>] kmem_cache_alloc+0x34/0x40
[1791648.043662]  [<c0180c83>] getname+0x23/0xf0
[1791648.048087]  [<c0178ebe>] do_sys_open+0x1e/0xe0
[1791648.052859]  [<c0178fbc>] sys_open+0x1c/0x20
[1791648.057370]  [<c0103ff6>] sysenter_past_esp+0x5f/0x85
[1791648.062660]  [<c0300000>] rt_mutex_slowlock+0x330/0x4a0
[1791648.069807]  =======================
[1791648.073620] Mem-info:
[1791648.076125] DMA per-cpu:
[1791648.078892] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791648.087613] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791648.096336] CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791648.105062] CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791648.113789] CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791648.122510] CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791648.131231] CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791648.139950] CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791648.148673] Normal per-cpu:
[1791648.151699] CPU    0: Hot: hi:  186, btch:  31 usd: 149   Cold: hi:  
62, btch:  15 usd:  60
[1791648.160422] CPU    1: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:  
62, btch:  15 usd:  47
[1791648.169141] CPU    2: Hot: hi:  186, btch:  31 usd:  53   Cold: hi:  
62, btch:  15 usd:  56
[1791648.178140] CPU    3: Hot: hi:  186, btch:  31 usd:  15   Cold: hi:  
62, btch:  15 usd:  61
[1791648.186860] CPU    4: Hot: hi:  186, btch:  31 usd:   9   Cold: hi:  
62, btch:  15 usd:  52
[1791648.195583] CPU    5: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:  
62, btch:  15 usd:  55
[1791648.204307] CPU    6: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:  
62, btch:  15 usd:  54
[1791648.213027] CPU    7: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:  
62, btch:  15 usd:  54
[1791648.221745] HighMem per-cpu:
[1791648.224858] CPU    0: Hot: hi:  186, btch:  31 usd: 107   Cold: hi:  
62, btch:  15 usd:   8
[1791648.233578] CPU    1: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:  
62, btch:  15 usd:   3
[1791648.242298] CPU    2: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:  
62, btch:  15 usd:   7
[1791648.251017] CPU    3: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:  
62, btch:  15 usd:   0
[1791648.259734] CPU    4: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:  
62, btch:  15 usd:   8
[1791648.268456] CPU    5: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:  
62, btch:  15 usd:   4
[1791648.277175] CPU    6: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:  
62, btch:  15 usd:   4
[1791648.285894] CPU    7: Hot: hi:  186, btch:  31 usd: 111   Cold: hi:  
62, btch:  15 usd:   8
[1791648.294615] Active:157832 inactive:3403 dirty:0 writeback:0 unstable:0
[1791648.294616]  free:1704052 slab:15060 mapped:2645 pagetables:1539
bounce:0
[1791648.308367] DMA free:3544kB min:68kB low:84kB high:100kB active:8kB
inactive:44kB present:16256kB pages_scanned:5433109 all_unreclaimable? yes
[1791648.321712] lowmem_reserve[]: 0 873 8874
[1791648.325914] Normal free:3744kB min:3744kB low:4680kB high:5616kB
active:716kB inactive:228kB present:894080kB pages_scanned:8756844
all_unreclaimable? yes
[1791648.339999] lowmem_reserve[]: 0 0 64008
[1791648.344110] HighMem free:6808920kB min:512kB low:9096kB high:17684kB
active:630792kB inactive:13452kB present:8193024kB pages_scanned:0
all_unreclaimable? no
[1791648.358531] lowmem_reserve[]: 0 0 0
[1791648.362298] DMA: 14*4kB 8*8kB 2*16kB 0*32kB 1*64kB 0*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 0*4096kB = 3544kB
[1791648.372719] Normal: 252*4kB 0*8kB 1*16kB 1*32kB 0*64kB 1*128kB
2*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3744kB
[1791648.383482] HighMem: 22420*4kB 54287*8kB 29463*16kB 9675*32kB
11033*64kB 5403*128kB 1622*256kB 523*512kB 203*1024kB 60*2048kB 755*4096kB
= 6808920kB
[1791648.397190] Swap cache: add 0, delete 0, find 0/0, race 0+0
[1791648.402986] Free swap  = 1024072kB
[1791648.406616] Total swap = 1024072kB
[1791648.410247] Free swap:       1024072kB
[1791648.438275] 2293759 pages of RAM
[1791648.441737] 2064383 pages of HIGHMEM
[1791648.445933] 216146 reserved pages
[1791648.449476] 193660 pages shared
[1791648.452849] 0 pages swap cached
[1791648.456218] 0 pages dirty
[1791648.459068] 0 pages writeback
[1791648.462268] 2645 pages mapped
[1791648.465465] 15060 pages slab
[1791648.468578] 1539 pages pagetables

[1791697.919505] atop invoked oom-killer: gfp_mask=0x200d0, order=0,
oomkilladj=0
[1791697.926857]  [<c015c2dd>] out_of_memory+0x18d/0x1d0
[1791697.931976]  [<c015d955>] __alloc_pages+0x315/0x340
[1791697.937095]  [<c015df63>] __get_free_pages+0x43/0x50
[1791697.942296]  [<c018bdc3>] sys_getcwd+0x13/0x1b0
[1791697.947069]  [<c0103ff6>] sysenter_past_esp+0x5f/0x85
[1791697.952359]  =======================
[1791697.956165] Mem-info:
[1791697.958670] DMA per-cpu:
[1791697.961437] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791697.970161] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791697.978883] CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791697.987606] CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791697.996330] CPU    4: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791698.005053] CPU    5: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791698.013775] CPU    6: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791698.022499] CPU    7: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:  
 0, btch:   1 usd:   0
[1791698.031515] Normal per-cpu:
[1791698.034540] CPU    0: Hot: hi:  186, btch:  31 usd: 149   Cold: hi:  
62, btch:  15 usd:  60
[1791698.043266] CPU    1: Hot: hi:  186, btch:  31 usd: 139   Cold: hi:  
62, btch:  15 usd:  47
[1791698.051988] CPU    2: Hot: hi:  186, btch:  31 usd:  55   Cold: hi:  
62, btch:  15 usd:  56
[1791698.060711] CPU    3: Hot: hi:  186, btch:  31 usd:  15   Cold: hi:  
62, btch:  15 usd:  61
[1791698.069443] CPU    4: Hot: hi:  186, btch:  31 usd:   8   Cold: hi:  
62, btch:  15 usd:  52
[1791698.078166] CPU    5: Hot: hi:  186, btch:  31 usd:  38   Cold: hi:  
62, btch:  15 usd:  55
[1791698.086889] CPU    6: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:  
62, btch:  15 usd:  54
[1791698.095613] CPU    7: Hot: hi:  186, btch:  31 usd:   7   Cold: hi:  
62, btch:  15 usd:  54
[1791698.104333] HighMem per-cpu:
[1791698.107447] CPU    0: Hot: hi:  186, btch:  31 usd: 107   Cold: hi:  
62, btch:  15 usd:   8
[1791698.116171] CPU    1: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:  
62, btch:  15 usd:   3
[1791698.124893] CPU    2: Hot: hi:  186, btch:  31 usd: 112   Cold: hi:  
62, btch:  15 usd:   7
[1791698.133614] CPU    3: Hot: hi:  186, btch:  31 usd:   6   Cold: hi:  
62, btch:  15 usd:   0
[1791698.142338] CPU    4: Hot: hi:  186, btch:  31 usd: 132   Cold: hi:  
62, btch:  15 usd:   8
[1791698.151063] CPU    5: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:  
62, btch:  15 usd:   4
[1791698.159790] CPU    6: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:  
62, btch:  15 usd:   4
[1791698.168756] CPU    7: Hot: hi:  186, btch:  31 usd: 111   Cold: hi:  
62, btch:  15 usd:   8
[1791698.177668] Active:157854 inactive:3577 dirty:0 writeback:0 unstable:0
[1791698.177669]  free:1704052 slab:15059 mapped:2645 pagetables:1539
bounce:0
[1791698.191426] DMA free:3544kB min:68kB low:84kB high:100kB active:80kB
inactive:44kB present:16256kB pages_scanned:5537477 all_unreclaimable? yes
[1791698.204559] lowmem_reserve[]: 0 873 8874
[1791698.208760] Normal free:3744kB min:3744kB low:4680kB high:5616kB
active:536kB inactive:700kB present:894080kB pages_scanned:9060588
all_unreclaimable? yes
[1791698.222844] lowmem_reserve[]: 0 0 64008
[1791698.226956] HighMem free:6808920kB min:512kB low:9096kB high:17684kB
active:630792kB inactive:13452kB present:8193024kB pages_scanned:0
all_unreclaimable? no
[1791698.241368] lowmem_reserve[]: 0 0 0
[1791698.245136] DMA: 14*4kB 8*8kB 2*16kB 0*32kB 1*64kB 0*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 0*4096kB = 3544kB
[1791698.255558] Normal: 252*4kB 0*8kB 1*16kB 1*32kB 0*64kB 1*128kB
2*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3744kB
[1791698.266321] HighMem: 22420*4kB 54287*8kB 29463*16kB 9675*32kB
11033*64kB 5403*128kB 1622*256kB 523*512kB 203*1024kB 60*2048kB 755*4096kB
= 6808920kB
[1791698.280026] Swap cache: add 0, delete 0, find 0/0, race 0+0
[1791698.285831] Free swap  = 1024072kB
[1791698.289463] Total swap = 1024072kB
[1791698.293094] Free swap:       1024072kB
[1791698.321500] 2293759 pages of RAM
[1791698.324964] 2064383 pages of HIGHMEM
[1791698.328767] 216146 reserved pages
[1791698.332311] 193661 pages shared
[1791698.335684] 0 pages swap cached
[1791698.339055] 0 pages dirty
[1791698.341906] 0 pages writeback
[1791698.345103] 2645 pages mapped
[1791698.348302] 15059 pages slab
[1791698.351413] 1539 pages pagetables

I could get these messages because we are running here console servers
with a memory dump.

Anyhow, what could be causing this error? The system is running ReiserFS.

Hope you guys can help.

Greetings,

Jim.
