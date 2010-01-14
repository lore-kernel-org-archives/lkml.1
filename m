Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654Ab0ANNNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0ANNNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590Ab0ANNNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:13:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59740 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab0ANNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:date:to:subject:mime-version:content-transfer-encoding
         :from:message-id:user-agent;
        b=SUpFADZ8rbmI4gzH4RXeghJIeSLoujTUP8GjZdSQ5+nmE8gz3TPwnIrUBb8UolGXRl
         qM/u96T57Ut2cag99lv2XSZe1yr8cJ7Xu97/zu/GapD9gN3xYYwbX1cwkqzl7jJGv08u
         Fu0t1rQqUDOElYvJWecnCPzPA5hApdAPl1Gbg=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 14 Jan 2010 14:15:59 +0100
To: lkml <linux-kernel@vger.kernel.org>
Subject: OOM-Killer kills too much with 2.6.32.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Roman Jarosz" <kedgedev@gmail.com>
Message-ID: <op.u6ixswy6asvm2a@kedge>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since kernel 2.6.32.2 (also tried 2.6.32.3) I get a lot of oom-killer  
kills when I do hard disk intensive tasks (mainly in VirtualBox which is  
running Windows XP) and IMHO it kills processes even if I have a lot of  
free memory.

Is this a known bug? I have self compiled kernel so I can try patches.

Regards
Roman Jarosz

PS. Please CC me.

Jan  7 12:39:27 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,  
oom_adj=0
Jan  7 12:39:27 kedge kernel: Pid: 1954, comm: X Not tainted 2.6.32.2 #1
Jan  7 12:39:27 kedge kernel: Call Trace:
Jan  7 12:39:27 kedge kernel: [<ffffffff8107b17d>] ? 0xffffffff8107b17d
Jan  7 12:39:27 kedge kernel: [<ffffffff8107b463>] ? 0xffffffff8107b463
Jan  7 12:39:27 kedge kernel: [<ffffffff8107b5d7>] ? 0xffffffff8107b5d7
Jan  7 12:39:27 kedge kernel: [<ffffffff815581df>] ? 0xffffffff815581df
Jan  7 12:39:27 kedge kernel: Mem-Info:
Jan  7 12:39:27 kedge kernel: DMA per-cpu:
Jan  7 12:39:27 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan  7 12:39:27 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan  7 12:39:27 kedge kernel: DMA32 per-cpu:
Jan  7 12:39:27 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 158
Jan  7 12:39:27 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 134
Jan  7 12:39:27 kedge kernel: Normal per-cpu:
Jan  7 12:39:27 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 200
Jan  7 12:39:27 kedge kernel: CPU    1: hi:  186, btch:  31 usd:  67
Jan  7 12:39:27 kedge kernel: active_anon:420176 inactive_anon:150891  
isolated_anon:0
Jan  7 12:39:27 kedge kernel: active_file:163989 inactive_file:204935  
isolated_file:32
Jan  7 12:39:27 kedge kernel: unevictable:0 dirty:74867 writeback:5410  
unstable:0
Jan  7 12:39:27 kedge kernel: free:6848 slab_reclaimable:12678  
slab_unreclaimable:12867
Jan  7 12:39:27 kedge kernel: mapped:72453 shmem:82598 pagetables:7517  
bounce:0
Jan  7 12:39:27 kedge kernel: DMA free:15776kB min:28kB low:32kB high:40kB  
active_anon:12kB inactive_anon:52kB active_file:4kB inactive_file:80kB  
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB  
mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:4kB  
slab_reclaimable:0kB slab_unreclaimable:20kB kernel_stack:0kB  
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0  
all_unreclaimable? no
Jan  7 12:39:27 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan  7 12:39:27 kedge kernel: DMA32 free:9712kB min:6084kB low:7604kB  
high:9124kB active_anon:1469976kB inactive_anon:370840kB  
active_file:445776kB inactive_file:565080kB unevictable:0kB  
isolated(anon):0kB isolated(file):128kB present:3062688kB mlocked:0kB  
dirty:212584kB writeback:14288kB mapped:165804kB shmem:190264kB  
slab_reclaimable:30104kB slab_unreclaimable:34300kB kernel_stack:840kB  
pagetables:14756kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:32 all_unreclaimable? no
Jan  7 12:39:27 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan  7 12:39:27 kedge kernel: Normal free:1904kB min:1924kB low:2404kB  
high:2884kB active_anon:210716kB inactive_anon:232672kB  
active_file:210176kB inactive_file:254580kB unevictable:0kB  
isolated(anon):0kB isolated(file):0kB present:969600kB mlocked:0kB  
dirty:86784kB writeback:7452kB mapped:124004kB shmem:140124kB  
slab_reclaimable:20608kB slab_unreclaimable:17148kB kernel_stack:1792kB  
pagetables:15312kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:0 all_unreclaimable? no
Jan  7 12:39:27 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan  7 12:39:27 kedge kernel: DMA: 2*4kB 3*8kB 2*16kB 3*32kB 2*64kB  
3*128kB 3*256kB 2*512kB 3*1024kB 3*2048kB 1*4096kB = 15776kB
Jan  7 12:39:27 kedge kernel: DMA32: 486*4kB 9*8kB 0*16kB 1*32kB 1*64kB  
1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 9664kB
Jan  7 12:39:27 kedge kernel: Normal: 442*4kB 11*8kB 3*16kB 0*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1904kB
Jan  7 12:39:27 kedge kernel: 451672 total pagecache pages
Jan  7 12:39:27 kedge kernel: 103 pages in swap cache
Jan  7 12:39:27 kedge kernel: Swap cache stats: add 6976, delete 6873,  
find 0/0
Jan  7 12:39:27 kedge kernel: Free swap  = 1980212kB
Jan  7 12:39:27 kedge kernel: Total swap = 2008116kB
Jan  7 12:39:27 kedge kernel: 1032192 pages RAM
Jan  7 12:39:27 kedge kernel: 45505 pages reserved
Jan  7 12:39:27 kedge kernel: 692298 pages shared
Jan  7 12:39:27 kedge kernel: 449041 pages non-shared
Jan  7 12:39:27 kedge kernel: Out of memory: kill process 2774  
(services.exe) score 51635 or a child
Jan  7 12:39:27 kedge kernel: Killed process 2776 (winedevice.exe)
Jan  7 12:39:28 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,  
oom_adj=0
Jan  7 12:39:28 kedge kernel: Pid: 1954, comm: X Not tainted 2.6.32.2 #1
Jan  7 12:39:28 kedge kernel: Call Trace:
Jan  7 12:39:28 kedge kernel: [<ffffffff8107b17d>] ? 0xffffffff8107b17d
Jan  7 12:39:28 kedge kernel: [<ffffffff8107b463>] ? 0xffffffff8107b463
Jan  7 12:39:28 kedge kernel: [<ffffffff8107b5d7>] ? 0xffffffff8107b5d7
Jan  7 12:39:28 kedge kernel: [<ffffffff815581df>] ? 0xffffffff815581df
Jan  7 12:39:28 kedge kernel: Mem-Info:
Jan  7 12:39:28 kedge kernel: DMA per-cpu:
Jan  7 12:39:28 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan  7 12:39:28 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan  7 12:39:28 kedge kernel: DMA32 per-cpu:
Jan  7 12:39:28 kedge kernel: CPU    0: hi:  186, btch:  31 usd:  93
Jan  7 12:39:28 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 142
Jan  7 12:39:28 kedge kernel: Normal per-cpu:
Jan  7 12:39:28 kedge kernel: CPU    0: hi:  186, btch:  31 usd:  22
Jan  7 12:39:28 kedge kernel: CPU    1: hi:  186, btch:  31 usd:  79
Jan  7 12:39:28 kedge kernel: active_anon:420340 inactive_anon:150899  
isolated_anon:0
Jan  7 12:39:28 kedge kernel: active_file:163960 inactive_file:204984  
isolated_file:32
Jan  7 12:39:28 kedge kernel: unevictable:0 dirty:73435 writeback:5765  
unstable:0
Jan  7 12:39:28 kedge kernel: free:6862 slab_reclaimable:12728  
slab_unreclaimable:12913
Jan  7 12:39:28 kedge kernel: mapped:72491 shmem:82979 pagetables:7503  
bounce:0
Jan  7 12:39:28 kedge kernel: DMA free:15776kB min:28kB low:32kB high:40kB  
active_anon:12kB inactive_anon:52kB active_file:4kB inactive_file:80kB  
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB  
mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:4kB  
slab_reclaimable:0kB slab_unreclaimable:20kB kernel_stack:0kB  
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0  
all_unreclaimable? no
Jan  7 12:39:28 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan  7 12:39:28 kedge kernel: DMA32 free:9856kB min:6084kB low:7604kB  
high:9124kB active_anon:1470236kB inactive_anon:370840kB  
active_file:445788kB inactive_file:565160kB unevictable:0kB  
isolated(anon):0kB isolated(file):128kB present:3062688kB mlocked:0kB  
dirty:206716kB writeback:14880kB mapped:165724kB shmem:191300kB  
slab_reclaimable:30344kB slab_unreclaimable:34264kB kernel_stack:808kB  
pagetables:14700kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:320 all_unreclaimable? no
Jan  7 12:39:28 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan  7 12:39:28 kedge kernel: Normal free:1816kB min:1924kB low:2404kB  
high:2884kB active_anon:211112kB inactive_anon:232704kB  
active_file:210048kB inactive_file:254696kB unevictable:0kB  
isolated(anon):0kB isolated(file):0kB present:969600kB mlocked:0kB  
dirty:87024kB writeback:8180kB mapped:124236kB shmem:140612kB  
slab_reclaimable:20568kB slab_unreclaimable:17368kB kernel_stack:1792kB  
pagetables:15312kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:128 all_unreclaimable? no
Jan  7 12:39:28 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan  7 12:39:28 kedge kernel: DMA: 2*4kB 3*8kB 2*16kB 3*32kB 2*64kB  
3*128kB 3*256kB 2*512kB 3*1024kB 3*2048kB 1*4096kB = 15776kB
Jan  7 12:39:28 kedge kernel: DMA32: 501*4kB 6*8kB 10*16kB 2*32kB 1*64kB  
0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 9764kB
Jan  7 12:39:28 kedge kernel: Normal: 408*4kB 3*8kB 4*16kB 3*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1816kB
Jan  7 12:39:28 kedge kernel: 452076 total pagecache pages
Jan  7 12:39:28 kedge kernel: 110 pages in swap cache
Jan  7 12:39:28 kedge kernel: Swap cache stats: add 6984, delete 6874,  
find 0/1
Jan  7 12:39:28 kedge kernel: Free swap  = 1980216kB
Jan  7 12:39:28 kedge kernel: Total swap = 2008116kB
Jan  7 12:39:28 kedge kernel: 1032192 pages RAM
Jan  7 12:39:28 kedge kernel: 45505 pages reserved
Jan  7 12:39:28 kedge kernel: 693720 pages shared
Jan  7 12:39:28 kedge kernel: 447481 pages non-shared
Jan  7 12:39:28 kedge kernel: Out of memory: kill process 2284 (kdeinit4)  
score 40807 or a child
Jan  7 12:39:28 kedge kernel: Killed process 2285 (klauncher)
Jan  7 12:39:37 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,  
oom_adj=0
Jan  7 12:39:37 kedge kernel: Pid: 1954, comm: X Not tainted 2.6.32.2 #1
Jan  7 12:39:37 kedge kernel: Call Trace:
Jan  7 12:39:37 kedge kernel: [<ffffffff8107b17d>] ? 0xffffffff8107b17d
Jan  7 12:39:37 kedge kernel: [<ffffffff8107b463>] ? 0xffffffff8107b463
Jan  7 12:39:37 kedge kernel: [<ffffffff8107b5d7>] ? 0xffffffff8107b5d7
Jan  7 12:39:37 kedge kernel: [<ffffffff815581df>] ? 0xffffffff815581df
Jan  7 12:39:37 kedge kernel: Mem-Info:
Jan  7 12:39:37 kedge kernel: DMA per-cpu:
Jan  7 12:39:37 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan  7 12:39:37 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan  7 12:39:37 kedge kernel: DMA32 per-cpu:
Jan  7 12:39:37 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 148
Jan  7 12:39:37 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 185
Jan  7 12:39:37 kedge kernel: Normal per-cpu:
Jan  7 12:39:37 kedge kernel: CPU    0: hi:  186, btch:  31 usd:  75
Jan  7 12:39:37 kedge kernel: CPU    1: hi:  186, btch:  31 usd:  82
Jan  7 12:39:37 kedge kernel: active_anon:420619 inactive_anon:150667  
isolated_anon:0
Jan  7 12:39:37 kedge kernel: active_file:163905 inactive_file:205729  
isolated_file:32
Jan  7 12:39:37 kedge kernel: unevictable:0 dirty:81537 writeback:3643  
unstable:0
Jan  7 12:39:37 kedge kernel: free:6887 slab_reclaimable:12055  
slab_unreclaimable:12667
Jan  7 12:39:37 kedge kernel: mapped:72567 shmem:83099 pagetables:7502  
bounce:0
Jan  7 12:39:37 kedge kernel: DMA free:15776kB min:28kB low:32kB high:40kB  
active_anon:12kB inactive_anon:52kB active_file:4kB inactive_file:80kB  
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB  
mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:4kB  
slab_reclaimable:0kB slab_unreclaimable:20kB kernel_stack:0kB  
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0  
all_unreclaimable? no
Jan  7 12:39:37 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan  7 12:39:37 kedge kernel: DMA32 free:9856kB min:6084kB low:7604kB  
high:9124kB active_anon:1469840kB inactive_anon:370824kB  
active_file:445864kB inactive_file:567788kB unevictable:0kB  
isolated(anon):0kB isolated(file):0kB present:3062688kB mlocked:0kB  
dirty:227772kB writeback:10748kB mapped:165964kB shmem:190888kB  
slab_reclaimable:28496kB slab_unreclaimable:33328kB kernel_stack:808kB  
pagetables:14700kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:192 all_unreclaimable? no
Jan  7 12:39:37 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan  7 12:39:37 kedge kernel: Normal free:1916kB min:1924kB low:2404kB  
high:2884kB active_anon:212624kB inactive_anon:231792kB  
active_file:209752kB inactive_file:255048kB unevictable:0kB  
isolated(anon):0kB isolated(file):128kB present:969600kB mlocked:0kB  
dirty:98376kB writeback:3824kB mapped:124300kB shmem:141504kB  
slab_reclaimable:19724kB slab_unreclaimable:17320kB kernel_stack:1792kB  
pagetables:15308kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:0 all_unreclaimable? no
Jan  7 12:39:37 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan  7 12:39:37 kedge kernel: DMA: 2*4kB 3*8kB 2*16kB 3*32kB 2*64kB  
3*128kB 3*256kB 2*512kB 3*1024kB 3*2048kB 1*4096kB = 15776kB
Jan  7 12:39:37 kedge kernel: DMA32: 504*4kB 0*8kB 10*16kB 8*32kB 4*64kB  
0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 9856kB
Jan  7 12:39:37 kedge kernel: Normal: 479*4kB 0*8kB 1*16kB 0*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1932kB
Jan  7 12:39:37 kedge kernel: 452912 total pagecache pages
Jan  7 12:39:37 kedge kernel: 110 pages in swap cache
Jan  7 12:39:37 kedge kernel: Swap cache stats: add 6984, delete 6874,  
find 0/1
Jan  7 12:39:37 kedge kernel: Free swap  = 1980216kB
Jan  7 12:39:37 kedge kernel: Total swap = 2008116kB
Jan  7 12:39:37 kedge kernel: 1032192 pages RAM
Jan  7 12:39:37 kedge kernel: 45505 pages reserved
Jan  7 12:39:37 kedge kernel: 673963 pages shared
Jan  7 12:39:37 kedge kernel: 466837 pages non-shared
Jan  7 12:39:37 kedge kernel: Out of memory: kill process 2284 (kdeinit4)  
score 40802 or a child
Jan  7 12:39:37 kedge kernel: Killed process 2315 (ksmserver)


Jan  7 14:55:00 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,  
oom_adj=0
Jan  7 14:55:00 kedge kernel: Pid: 1949, comm: X Not tainted 2.6.32.2 #1
Jan  7 14:55:00 kedge kernel: Call Trace:
Jan  7 14:55:00 kedge kernel: [<ffffffff8107b17d>] ? 0xffffffff8107b17d
Jan  7 14:55:00 kedge kernel: [<ffffffff8107b463>] ? 0xffffffff8107b463
Jan  7 14:55:00 kedge kernel: [<ffffffff8107b5d7>] ? 0xffffffff8107b5d7
Jan  7 14:55:00 kedge kernel: [<ffffffff815581df>] ? 0xffffffff815581df
Jan  7 14:55:00 kedge kernel: Mem-Info:
Jan  7 14:55:00 kedge kernel: DMA per-cpu:
Jan  7 14:55:00 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan  7 14:55:00 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan  7 14:55:00 kedge kernel: DMA32 per-cpu:
Jan  7 14:55:00 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 124
Jan  7 14:55:00 kedge kernel: CPU    1: hi:  186, btch:  31 usd:  64
Jan  7 14:55:00 kedge kernel: Normal per-cpu:
Jan  7 14:55:00 kedge kernel: CPU    0: hi:  186, btch:  31 usd:  60
Jan  7 14:55:00 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 124
Jan  7 14:55:00 kedge kernel: active_anon:428715 inactive_anon:170886  
isolated_anon:0
Jan  7 14:55:00 kedge kernel: active_file:83424 inactive_file:259387  
isolated_file:64
Jan  7 14:55:00 kedge kernel: unevictable:52 dirty:134577 writeback:3053  
unstable:0
Jan  7 14:55:00 kedge kernel: free:6862 slab_reclaimable:14067  
slab_unreclaimable:11265
Jan  7 14:55:00 kedge kernel: mapped:48961 shmem:78608 pagetables:5783  
bounce:0
Jan  7 14:55:00 kedge kernel: DMA free:15776kB min:28kB low:32kB high:40kB  
active_anon:32kB inactive_anon:128kB active_file:0kB inactive_file:0kB  
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB  
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB  
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB  
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0  
all_unreclaimable? no
Jan  7 14:55:00 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan  7 14:55:00 kedge kernel: DMA32 free:9760kB min:6084kB low:7604kB  
high:9124kB active_anon:1415932kB inactive_anon:363400kB  
active_file:206448kB inactive_file:873788kB unevictable:0kB  
isolated(anon):0kB isolated(file):0kB present:3062688kB mlocked:0kB  
dirty:457220kB writeback:6548kB mapped:87700kB shmem:173796kB  
slab_reclaimable:37724kB slab_unreclaimable:27968kB kernel_stack:408kB  
pagetables:8040kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:192 all_unreclaimable? no
Jan  7 14:55:00 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan  7 14:55:00 kedge kernel: Normal free:1912kB min:1924kB low:2404kB  
high:2884kB active_anon:298896kB inactive_anon:320016kB  
active_file:127248kB inactive_file:163760kB unevictable:208kB  
isolated(anon):0kB isolated(file):256kB present:969600kB mlocked:208kB  
dirty:81088kB writeback:5664kB mapped:108144kB shmem:140636kB  
slab_reclaimable:18544kB slab_unreclaimable:17084kB kernel_stack:1848kB  
pagetables:15092kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:128 all_unreclaimable? no
Jan  7 14:55:00 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan  7 14:55:00 kedge kernel: DMA: 0*4kB 2*8kB 1*16kB 2*32kB 1*64kB  
2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15776kB
Jan  7 14:55:00 kedge kernel: DMA32: 292*4kB 154*8kB 29*16kB 4*32kB 4*64kB  
3*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 1*4096kB = 9776kB
Jan  7 14:55:00 kedge kernel: Normal: 322*4kB 70*8kB 4*16kB 0*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1912kB
Jan  7 14:55:00 kedge kernel: 421622 total pagecache pages
Jan  7 14:55:00 kedge kernel: 77 pages in swap cache
Jan  7 14:55:00 kedge kernel: Swap cache stats: add 332, delete 255, find  
25/33
Jan  7 14:55:00 kedge kernel: Free swap  = 2007408kB
Jan  7 14:55:00 kedge kernel: Total swap = 2008116kB
Jan  7 14:55:00 kedge kernel: 1032192 pages RAM
Jan  7 14:55:00 kedge kernel: 45505 pages reserved
Jan  7 14:55:00 kedge kernel: 698655 pages shared
Jan  7 14:55:00 kedge kernel: 395124 pages non-shared
Jan  7 14:55:00 kedge kernel: Out of memory: kill process 2292 (kdeinit4)  
score 31321 or a child
Jan  7 14:55:00 kedge kernel: Killed process 2293 (klauncher)



Jan  8 11:47:13 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,  
oom_adj=0
Jan  8 11:47:13 kedge kernel: Pid: 1947, comm: X Not tainted 2.6.32.2 #1
Jan  8 11:47:13 kedge kernel: Call Trace:
Jan  8 11:47:13 kedge kernel: [<ffffffff8107b17d>] ? 0xffffffff8107b17d
Jan  8 11:47:13 kedge kernel: [<ffffffff8107b463>] ? 0xffffffff8107b463
Jan  8 11:47:13 kedge kernel: [<ffffffff8107b5d7>] ? 0xffffffff8107b5d7
Jan  8 11:47:13 kedge kernel: [<ffffffff815581df>] ? 0xffffffff815581df
Jan  8 11:47:13 kedge kernel: Mem-Info:
Jan  8 11:47:13 kedge kernel: DMA per-cpu:
Jan  8 11:47:13 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan  8 11:47:13 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan  8 11:47:13 kedge kernel: DMA32 per-cpu:
Jan  8 11:47:13 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 176
Jan  8 11:47:13 kedge kernel: CPU    1: hi:  186, btch:  31 usd:  37
Jan  8 11:47:13 kedge kernel: Normal per-cpu:
Jan  8 11:47:13 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 162
Jan  8 11:47:13 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 184
Jan  8 11:47:13 kedge kernel: active_anon:477285 inactive_anon:203470  
isolated_anon:224
Jan  8 11:47:13 kedge kernel: active_file:2741 inactive_file:2702  
isolated_file:1
Jan  8 11:47:13 kedge kernel: unevictable:262400 dirty:3 writeback:7734  
unstable:0
Jan  8 11:47:13 kedge kernel: free:6860 slab_reclaimable:4386  
slab_unreclaimable:12827
Jan  8 11:47:13 kedge kernel: mapped:15209 shmem:45527 pagetables:7496  
bounce:0
Jan  8 11:47:13 kedge kernel: DMA free:15764kB min:28kB low:32kB high:40kB  
active_anon:32kB inactive_anon:140kB active_file:0kB inactive_file:0kB  
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB  
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB  
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB  
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0  
all_unreclaimable? no
Jan  8 11:47:13 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan  8 11:47:13 kedge kernel: DMA32 free:9752kB min:6084kB low:7604kB  
high:9124kB active_anon:1460924kB inactive_anon:365512kB  
active_file:4012kB inactive_file:4152kB unevictable:1047324kB  
isolated(anon):508kB isolated(file):4kB present:3062688kB  
mlocked:1047324kB dirty:8kB writeback:11656kB mapped:50396kB  
shmem:112632kB slab_reclaimable:7736kB slab_unreclaimable:30688kB  
kernel_stack:608kB pagetables:12120kB unstable:0kB bounce:0kB  
writeback_tmp:0kB pages_scanned:1352 all_unreclaimable? no
Jan  8 11:47:13 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan  8 11:47:13 kedge kernel: Normal free:1924kB min:1924kB low:2404kB  
high:2884kB active_anon:448184kB inactive_anon:448328kB active_file:6952kB  
inactive_file:6656kB unevictable:2276kB isolated(anon):260kB  
isolated(file):0kB present:969600kB mlocked:2276kB dirty:4kB  
writeback:19280kB mapped:10440kB shmem:69476kB slab_reclaimable:9808kB  
slab_unreclaimable:20612kB kernel_stack:1744kB pagetables:17864kB  
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:96  
all_unreclaimable? no
Jan  8 11:47:13 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan  8 11:47:13 kedge kernel: DMA: 1*4kB 2*8kB 2*16kB 1*32kB 1*64kB  
2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15764kB
Jan  8 11:47:13 kedge kernel: DMA32: 144*4kB 95*8kB 14*16kB 0*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 9752kB
Jan  8 11:47:14 kedge kernel: Normal: 465*4kB 8*8kB 0*16kB 0*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1924kB
Jan  8 11:47:14 kedge kernel: 63561 total pagecache pages
Jan  8 11:47:14 kedge kernel: 12649 pages in swap cache
Jan  8 11:47:14 kedge kernel: Swap cache stats: add 562887, delete 550238,  
find 1428/2715
Jan  8 11:47:14 kedge kernel: Free swap  = 848784kB
Jan  8 11:47:14 kedge kernel: Total swap = 2008116kB
Jan  8 11:47:14 kedge kernel: 1032192 pages RAM
Jan  8 11:47:14 kedge kernel: 45505 pages reserved
Jan  8 11:47:14 kedge kernel: 307214 pages shared
Jan  8 11:47:14 kedge kernel: 688958 pages non-shared
Jan  8 11:47:14 kedge kernel: Out of memory: kill process 2277 (kdeinit4)  
score 68719 or a child
Jan  8 11:47:14 kedge kernel: Killed process 2278 (klauncher)
Jan  8 11:47:51 kedge kernel: VirtualBox[2607]: segfault at 7f067e56783c  
ip 00007f0695e16a00 sp 00007fffcec60018 error 4 in  
libc-2.11.so[7f0695d96000+150000]


Jan 12 10:39:57 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,  
oom_adj=0
Jan 12 10:39:57 kedge kernel: Pid: 1897, comm: X Not tainted 2.6.32.3 #1
Jan 12 10:39:57 kedge kernel: Call Trace:
Jan 12 10:39:57 kedge kernel: [<ffffffff8107b2dd>] ? 0xffffffff8107b2dd
Jan 12 10:39:57 kedge kernel: [<ffffffff8107b5c3>] ? 0xffffffff8107b5c3
Jan 12 10:39:57 kedge kernel: [<ffffffff8107b737>] ? 0xffffffff8107b737
Jan 12 10:39:57 kedge kernel: [<ffffffff8155eb1f>] ? 0xffffffff8155eb1f
Jan 12 10:39:57 kedge kernel: Mem-Info:
Jan 12 10:39:57 kedge kernel: DMA per-cpu:
Jan 12 10:39:57 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan 12 10:39:57 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan 12 10:39:57 kedge kernel: DMA32 per-cpu:
Jan 12 10:39:57 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 115
Jan 12 10:39:57 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 105
Jan 12 10:39:57 kedge kernel: Normal per-cpu:
Jan 12 10:39:57 kedge kernel: CPU    0: hi:  186, btch:  31 usd:  76
Jan 12 10:39:57 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 157
Jan 12 10:39:57 kedge kernel: active_anon:370078 inactive_anon:134712  
isolated_anon:0
Jan 12 10:39:57 kedge kernel: active_file:207094 inactive_file:231726  
isolated_file:33
Jan 12 10:39:57 kedge kernel: unevictable:0 dirty:110374 writeback:2787  
unstable:0
Jan 12 10:39:57 kedge kernel: free:6854 slab_reclaimable:14273  
slab_unreclaimable:10152
Jan 12 10:39:57 kedge kernel: mapped:44713 shmem:60225 pagetables:5405  
bounce:0
Jan 12 10:39:57 kedge kernel: DMA free:15760kB min:28kB low:32kB high:40kB  
active_anon:0kB inactive_anon:0kB active_file:96kB inactive_file:68kB  
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB  
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB  
slab_reclaimable:12kB slab_unreclaimable:8kB kernel_stack:0kB  
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0  
all_unreclaimable? no
Jan 12 10:39:57 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan 12 10:39:57 kedge kernel: DMA32 free:9852kB min:6084kB low:7604kB  
high:9124kB active_anon:1302612kB inactive_anon:338676kB  
active_file:581560kB inactive_file:644216kB unevictable:0kB  
isolated(anon):0kB isolated(file):132kB present:3062688kB mlocked:0kB  
dirty:361808kB writeback:8408kB mapped:73948kB shmem:127740kB  
slab_reclaimable:33636kB slab_unreclaimable:23436kB kernel_stack:696kB  
pagetables:7780kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:128 all_unreclaimable? no
Jan 12 10:39:57 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan 12 10:39:57 kedge kernel: Normal free:1804kB min:1924kB low:2404kB  
high:2884kB active_anon:177700kB inactive_anon:200172kB  
active_file:246720kB inactive_file:282620kB unevictable:0kB  
isolated(anon):0kB isolated(file):0kB present:969600kB mlocked:0kB  
dirty:79688kB writeback:2740kB mapped:104904kB shmem:113160kB  
slab_reclaimable:23444kB slab_unreclaimable:17164kB kernel_stack:1736kB  
pagetables:13840kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:0 all_unreclaimable? no
Jan 12 10:39:57 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan 12 10:39:57 kedge kernel: DMA: 2*4kB 1*8kB 2*16kB 3*32kB 2*64kB  
3*128kB 3*256kB 2*512kB 3*1024kB 3*2048kB 1*4096kB = 15760kB
Jan 12 10:39:57 kedge kernel: DMA32: 119*4kB 4*8kB 74*16kB 31*32kB 14*64kB  
1*128kB 2*256kB 1*512kB 1*1024kB 0*2048kB 1*4096kB = 9852kB
Jan 12 10:39:57 kedge kernel: Normal: 459*4kB 0*8kB 0*16kB 0*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1836kB
Jan 12 10:39:57 kedge kernel: 500016 total pagecache pages
Jan 12 10:39:57 kedge kernel: 874 pages in swap cache
Jan 12 10:39:57 kedge kernel: Swap cache stats: add 7068, delete 6194,  
find 365/500
Jan 12 10:39:57 kedge kernel: Free swap  = 1985148kB
Jan 12 10:39:57 kedge kernel: Total swap = 2008116kB
Jan 12 10:39:57 kedge kernel: 1032192 pages RAM
Jan 12 10:39:57 kedge kernel: 45537 pages reserved
Jan 12 10:39:57 kedge kernel: 717169 pages shared
Jan 12 10:39:57 kedge kernel: 368611 pages non-shared
Jan 12 10:39:57 kedge kernel: Out of memory: kill process 2245 (kdeinit4)  
score 6562989 or a child
Jan 12 10:39:57 kedge kernel: Killed process 2246 (klauncher)

Jan 13 14:56:29 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,  
oom_adj=0
Jan 13 14:56:29 kedge kernel: Pid: 1896, comm: X Not tainted 2.6.32.3 #1
Jan 13 14:56:29 kedge kernel: Call Trace:
Jan 13 14:56:29 kedge kernel: [<ffffffff8107b2dd>] ? 0xffffffff8107b2dd
Jan 13 14:56:29 kedge kernel: [<ffffffff8107b5c3>] ? 0xffffffff8107b5c3
Jan 13 14:56:29 kedge kernel: [<ffffffff8107b737>] ? 0xffffffff8107b737
Jan 13 14:56:29 kedge kernel: [<ffffffff8155eb1f>] ? 0xffffffff8155eb1f
Jan 13 14:56:29 kedge kernel: Mem-Info:
Jan 13 14:56:29 kedge kernel: DMA per-cpu:
Jan 13 14:56:29 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan 13 14:56:30 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan 13 14:56:30 kedge kernel: DMA32 per-cpu:
Jan 13 14:56:30 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 102
Jan 13 14:56:30 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 164
Jan 13 14:56:30 kedge kernel: Normal per-cpu:
Jan 13 14:56:30 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 105
Jan 13 14:56:30 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 176
Jan 13 14:56:30 kedge kernel: active_anon:632132 inactive_anon:230704  
isolated_anon:32
Jan 13 14:56:30 kedge kernel: active_file:39830 inactive_file:38082  
isolated_file:34
Jan 13 14:56:30 kedge kernel: unevictable:16 dirty:337 writeback:337  
unstable:0
Jan 13 14:56:30 kedge kernel: free:6865 slab_reclaimable:8416  
slab_unreclaimable:16167
Jan 13 14:56:30 kedge kernel: mapped:43419 shmem:84996 pagetables:6944  
bounce:0
Jan 13 14:56:30 kedge kernel: DMA free:15776kB min:28kB low:32kB high:40kB  
active_anon:0kB inactive_anon:0kB active_file:12kB inactive_file:144kB  
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB  
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB  
slab_reclaimable:4kB slab_unreclaimable:8kB kernel_stack:0kB  
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0  
all_unreclaimable? no
Jan 13 14:56:30 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan 13 14:56:30 kedge kernel: DMA32 free:9768kB min:6084kB low:7604kB  
high:9124kB active_anon:2141204kB inactive_anon:535376kB  
active_file:93848kB inactive_file:90092kB unevictable:64kB  
isolated(anon):0kB isolated(file):0kB present:3062688kB mlocked:64kB  
dirty:88kB writeback:444kB mapped:107488kB shmem:187252kB  
slab_reclaimable:18856kB slab_unreclaimable:39592kB kernel_stack:1360kB  
pagetables:11092kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:0 all_unreclaimable? no
Jan 13 14:56:30 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan 13 14:56:30 kedge kernel: Normal free:1916kB min:1924kB low:2404kB  
high:2884kB active_anon:387324kB inactive_anon:387440kB  
active_file:65460kB inactive_file:62092kB unevictable:0kB  
isolated(anon):128kB isolated(file):136kB present:969600kB mlocked:0kB  
dirty:1260kB writeback:904kB mapped:66188kB shmem:152732kB  
slab_reclaimable:14804kB slab_unreclaimable:25068kB kernel_stack:2032kB  
pagetables:16684kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:226 all_unreclaimable? no
Jan 13 14:56:30 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan 13 14:56:30 kedge kernel: DMA: 2*4kB 3*8kB 2*16kB 3*32kB 2*64kB  
3*128kB 3*256kB 2*512kB 3*1024kB 3*2048kB 1*4096kB = 15776kB
Jan 13 14:56:30 kedge kernel: DMA32: 50*4kB 363*8kB 25*16kB 6*32kB 1*64kB  
1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 1*4096kB = 9776kB
Jan 13 14:56:30 kedge kernel: Normal: 337*4kB 53*8kB 9*16kB 0*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1916kB
Jan 13 14:56:30 kedge kernel: 168802 total pagecache pages
Jan 13 14:56:30 kedge kernel: 5824 pages in swap cache
Jan 13 14:56:30 kedge kernel: Swap cache stats: add 35239, delete 29415,  
find 3247/3937
Jan 13 14:56:30 kedge kernel: Free swap  = 6084124kB
Jan 13 14:56:30 kedge kernel: Total swap = 6202412kB
Jan 13 14:56:30 kedge kernel: 1032192 pages RAM
Jan 13 14:56:30 kedge kernel: 45537 pages reserved
Jan 13 14:56:30 kedge kernel: 454756 pages shared
Jan 13 14:56:30 kedge kernel: 627506 pages non-shared
Jan 13 14:56:30 kedge kernel: Out of memory: kill process 3607 (eclipse)  
score 11190403 or a child
Jan 13 14:56:30 kedge kernel: Killed process 3817 (java)

Jan 14 12:22:32 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,  
oom_adj=0
Jan 14 12:22:32 kedge kernel: Pid: 1877, comm: X Not tainted 2.6.32.3 #1
Jan 14 12:22:32 kedge kernel: Call Trace:
Jan 14 12:22:32 kedge kernel: [<ffffffff8107b2dd>] ? 0xffffffff8107b2dd
Jan 14 12:22:32 kedge kernel: [<ffffffff8107b5c3>] ? 0xffffffff8107b5c3
Jan 14 12:22:32 kedge kernel: [<ffffffff8107b737>] ? 0xffffffff8107b737
Jan 14 12:22:32 kedge kernel: [<ffffffff8155eb1f>] ? 0xffffffff8155eb1f
Jan 14 12:22:32 kedge kernel: Mem-Info:
Jan 14 12:22:32 kedge kernel: DMA per-cpu:
Jan 14 12:22:32 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan 14 12:22:32 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan 14 12:22:32 kedge kernel: DMA32 per-cpu:
Jan 14 12:22:32 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 147
Jan 14 12:22:32 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 125
Jan 14 12:22:32 kedge kernel: Normal per-cpu:
Jan 14 12:22:32 kedge kernel: CPU    0: hi:  186, btch:  31 usd:  58
Jan 14 12:22:32 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 117
Jan 14 12:22:32 kedge kernel: active_anon:159855 inactive_anon:145129  
isolated_anon:0
Jan 14 12:22:32 kedge kernel: active_file:166370 inactive_file:477851  
isolated_file:35
Jan 14 12:22:32 kedge kernel: unevictable:1 dirty:165274 writeback:2333  
unstable:0
Jan 14 12:22:32 kedge kernel: free:6860 slab_reclaimable:15652  
slab_unreclaimable:11286
Jan 14 12:22:32 kedge kernel: mapped:47579 shmem:63280 pagetables:5848  
bounce:0
Jan 14 12:22:32 kedge kernel: DMA free:15760kB min:28kB low:32kB high:40kB  
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:176kB  
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB  
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB  
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB  
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0  
all_unreclaimable? no
Jan 14 12:22:32 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan 14 12:22:32 kedge kernel: DMA32 free:9852kB min:6084kB low:7604kB  
high:9124kB active_anon:422628kB inactive_anon:354268kB  
active_file:449432kB inactive_file:1660944kB unevictable:0kB  
isolated(anon):0kB isolated(file):140kB present:3062688kB mlocked:0kB  
dirty:575624kB writeback:8540kB mapped:59012kB shmem:141264kB  
slab_reclaimable:41560kB slab_unreclaimable:27284kB kernel_stack:832kB  
pagetables:10048kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:320 all_unreclaimable? no
Jan 14 12:22:32 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan 14 12:22:32 kedge kernel: Normal free:1828kB min:1924kB low:2404kB  
high:2884kB active_anon:216792kB inactive_anon:226248kB  
active_file:216048kB inactive_file:250284kB unevictable:4kB  
isolated(anon):0kB isolated(file):0kB present:969600kB mlocked:4kB  
dirty:85472kB writeback:792kB mapped:131304kB shmem:111856kB  
slab_reclaimable:21048kB slab_unreclaimable:17852kB kernel_stack:1816kB  
pagetables:13344kB unstable:0kB bounce:0kB writeback_tmp:0kB  
pages_scanned:96 all_unreclaimable? no
Jan 14 12:22:32 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan 14 12:22:32 kedge kernel: DMA: 0*4kB 2*8kB 2*16kB 1*32kB 1*64kB  
2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15760kB
Jan 14 12:22:32 kedge kernel: DMA32: 467*4kB 0*8kB 4*16kB 4*32kB 2*64kB  
0*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 9868kB
Jan 14 12:22:32 kedge kernel: Normal: 457*4kB 0*8kB 0*16kB 0*32kB 0*64kB  
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1828kB
Jan 14 12:22:32 kedge kernel: 707519 total pagecache pages
Jan 14 12:22:32 kedge kernel: 0 pages in swap cache
Jan 14 12:22:32 kedge kernel: Swap cache stats: add 25, delete 25, find 0/0
Jan 14 12:22:32 kedge kernel: Free swap  = 2008016kB
Jan 14 12:22:32 kedge kernel: Total swap = 2008116kB
Jan 14 12:22:32 kedge kernel: 1032192 pages RAM
Jan 14 12:22:32 kedge kernel: 36884 pages reserved
Jan 14 12:22:32 kedge kernel: 511141 pages shared
Jan 14 12:22:32 kedge kernel: 607236 pages non-shared
Jan 14 12:22:32 kedge kernel: Out of memory: kill process 2223 (kdeinit4)  
score 6720518 or a child
Jan 14 12:22:32 kedge kernel: Killed process 2224 (klauncher)


