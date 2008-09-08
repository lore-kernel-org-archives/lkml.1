Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYIHRgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYIHRgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYIHRgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:36:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYIHRf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:35:58 -0400
Date: Mon, 8 Sep 2008 19:35:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@redhat.com, joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] fix alloc_coherent allocation issues
	(tip/x86/iommu)
Message-ID: <20080908173525.GA23419@elte.hu>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080905181155W.fujita.tomonori@lab.ntt.co.jp> <20080905104518.GA17776@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905104518.GA17776@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., the build became very noisy - see the messages below.

	Ingo

---------->
init/initramfs.c:517: warning: 'clean_rootfs' defined but not used
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from init/main.c:48:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from arch/x86/kernel/pci-dma.c:2:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/probe_roms_32.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/pci-nommu.c:6:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/early-quirks.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/quirks.c:5:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/cpu/intel_cacheinfo.c:17:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/reboot_fixups_32.c:12:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/cpu/cpufreq/gx-suspmod.c:82:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
arch/x86/kernel/early_printk.c:993: warning: 'enable_debug_console' defined but not used
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/setup.c:48:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from include/asm/k8.h:5,
                 from arch/x86/kernel/k8.c:12:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/scx200_32.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/cpu/mtrr/main.c:37:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/kernel/io_apic.c:29:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
mm/bootmem.c: In function 'mark_bootmem':
mm/bootmem.c:321: warning: control reaches end of non-void function
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from include/linux/delayacct.h:22,
                 from kernel/fork.c:56:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from include/linux/delayacct.h:22,
                 from mm/vmscan.c:42:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from ipc/mqueue.c:27:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from include/linux/delayacct.h:22,
                 from kernel/sched.c:65:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
fs/dcache.c: In function 'd_materialise_unique':
fs/dcache.c:1875: warning: control reaches end of non-void function
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from security/commoncap.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from kernel/exit.c:34:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from kernel/audit.h:25,
                 from kernel/signal.c:37:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from include/linux/delayacct.h:22,
                 from mm/memory.c:51:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:151: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:157: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from crypto/algapi.c:20:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from mm/dmapool.c:27:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
kernel/cpuset.c: In function 'scan_for_empty_cpusets':
kernel/cpuset.c:1939: warning: passing argument 1 of 'list_add_tail' discards qualifiers from pointer target type
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from crypto/ablkcipher.c:22:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from include/linux/delayacct.h:22,
                 from kernel/cgroup.c:46:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from crypto/aead.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from crypto/cryptomgr.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/callback.c:22:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/cell.c:19:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/ip.h:109,
                 from fs/afs/cmservice.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from include/linux/delayacct.h:22,
                 from kernel/delayacct.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from crypto/xcbc.c:29:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/dir.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/file.c:20:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/flock.c:14:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from kernel/taskstats.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from kernel/dma-coherent.c:7:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/inode.c:24:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/main.c:18:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/fsclient.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/misc.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/proc.c:19:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/security.c:19:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/server.c:15:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from include/net/sock.h:50,
                 from fs/afs/rxrpc.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/super.c:27:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/vlclient.c:15:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from fs/afs/netdevices.c:8:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/vlocation.c:17:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/vnode.c:19:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/volume.c:20:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/scsi/scsi_cmnd.h:5,
                 from block/blk-exec.c:15:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/write.c:18:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from fs/afs/internal.h:17,
                 from fs/afs/mntpt.c:22:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/scsi/scsi_cmnd.h:5,
                 from include/scsi/scsi.h:13,
                 from block/scsi_ioctl.c:32:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/i386.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/init.c:2:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/acpi/osl.c:35:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/direct.c:6:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/libata-core.c:46:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/olpc.c:29:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/acpi/reboot.c:3:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/block/cpqarray.c:25:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/scsi/scsi_cmnd.h:5,
                 from include/scsi/scsi.h:13,
                 from block/cmd-filter.c:27:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/ata_piix.c:88:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/fixup.c:8:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/scsi/scsi_cmnd.h:5,
                 from include/scsi/scsi.h:13,
                 from drivers/ata/libata-scsi.c:40:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/mmconfig_32.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/mmconfig-shared.c:14:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
drivers/block/xd.c: In function 'xd_init':
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/libata.h:33,
                 from drivers/ata/libata-pmp.c:12:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from include/net/sock.h:50,
                 from drivers/block/nbd.c:31:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/sata_promise.c:37:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/acpi.c:2:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/sata_sx4.c:84:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:157: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
block/cfq-iosched.c: In function 'cfq_async_queue_prio':
block/cfq-iosched.c:1501: warning: control reaches end of non-void function
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/pcbios.c:6:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/legacy.c:6:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/ahci.c:38:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/common.c:9:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/irq.c:10:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/clocksource/acpi_pm.c:24:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/libata-eh.c:37:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/block/sx8.c:17:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/early.c:3:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/crypto/geode-aes.c:12:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/edac/edac_core.h:29,
                 from drivers/edac/edac_device.c:33:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/sata_nv.c:42:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/sata_uli.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/edac/edac_core.h:29,
                 from drivers/edac/edac_mc.c:35:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/crypto/hifn_795x.c:26:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from drivers/firmware/dcdbas.c:25:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:151: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/edac/edac_core.h:29,
                 from drivers/edac/edac_mc_sysfs.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/firmware/iscsi_ibft_find.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/eisa/pci_eisa.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/edac/edac_core.h:29,
                 from drivers/edac/edac_pci_sysfs.c:14:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/edac/edac_core.h:29,
                 from drivers/edac/edac_module.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/libata-sff.c:37:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_amd.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_cmd640.c:19:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from arch/x86/pci/amd_bus.c:3:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/edac/edac_core.h:29,
                 from drivers/edac/edac_pci.c:29:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/edac/edac_core.h:29,
                 from drivers/edac/edac_device_sysfs.c:17:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/genetlink.h:5,
                 from include/net/genetlink.h:5,
                 from include/linux/taskstats_kern.h:13,
                 from include/linux/delayacct.h:22,
                 from fs/proc/array.c:81:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_cs5530.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_cmd64x.c:27:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/socket.c:69:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/802/psnap.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/802/p8022.c:20:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_cypress.c:14:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/8021q/vlan_core.c:2:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from drivers/base/platform.c:17:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/802/tr.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/rocket.c:85:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
drivers/char/rocket.c: At top level:
drivers/char/rocket.c:1873: warning: 'rocket_pci_ids' defined but not used
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/acpi/bus.c:39:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/nozomi.c:47:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/8021q/vlan.c:24:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/hw_random/intel-rng.c:31:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/mxser.c:40:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/hw_random/amd-rng.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/input/gameport/fm801-gp.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/epca.c:45:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
include/asm/io_32.h: In function 'memcpy_fromio':
include/asm/io_32.h:151: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
include/asm/io_32.h: In function 'memcpy_toio':
include/asm/io_32.h:157: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/i2c/busses/i2c-i801.c:59:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_efar.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/i2c/busses/i2c-amd8111.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/specialix.c:94:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
drivers/char/specialix.c: At top level:
drivers/char/specialix.c:2358: warning: 'specialx_pci_tbl' defined but not used
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/i2c/busses/i2c-sis630.c:52:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/ip2/ip2main.c:96:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
drivers/char/ip2/ip2main.c: At top level:
drivers/char/ip2/i2ellis.c:100: warning: 'iiEllisCleanup' defined but not used
drivers/char/ip2/ip2main.c:3178: warning: 'ip2main_pci_tbl' defined but not used
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/rio/rio_linux.c:46:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/synclinkmp.c:44:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/synclink.c:73:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/802/fc.c:23:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from lib/devres.c:2:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from lib/iomap.c:7:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/i2c/busses/i2c-voodoo3.c:32:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/802/hippi.c:32:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/icmpv6.h:80,
                 from include/linux/ipv6.h:208,
                 from net/9p/trans_fd.c:32:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/scsi/scsi_cmnd.h:5,
                 from include/scsi/scsi.h:13,
                 from include/scsi/scsi_host.h:10,
                 from drivers/ata/pata_isapnp.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/applicom.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/802/stp.c:12:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ieee1394/dma.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/sonypi.c:41:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ieee1394/iso.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/8021q/vlan_dev.c:25:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_it8213.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/input/serio/pcips2.c:18:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ieee1394/init_ohci1394_dma.c:38:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from include/net/sock.h:50,
                 from net/core/iovec.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/8021q/vlan_netlink.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from include/net/sock.h:50,
                 from include/net/request_sock.h:24,
                 from net/core/request_sock.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/tcp.h:176,
                 from net/core/sock.c:111:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/core/datagram.c:47:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/tcp.h:176,
                 from net/core/stream.c:19:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/ethernet/pe2.c:5:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/ip.h:109,
                 from net/ethernet/eth.c:49:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/decnet/dn_nsp_in.c:58:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/decnet/af_decnet.c:115:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/core/scm.c:26:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from include/linux/if_vlan.h:18,
                 from net/8021q/vlan_gvrp.c:12:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/i2c/busses/scx200_acb.c:32:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/8021q/vlanproc.c:28:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_ns87410.c:24:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from net/core/gen_stats.c:22:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_ninja32.c:41:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/core/gen_estimator.c:31:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/802/garp.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/decnet/dn_nsp_out.c:51:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/acpi/pci_root.c:34:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/decnet/dn_route.c:66:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_radisys.c:18:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_oldpiix.c:19:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from net/core/net_namespace.c:3:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/core/sysctl_net_core.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
lib/debugobjects.c:58: warning: 'obj_states' defined but not used
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/ip.h:109,
                 from include/net/ip.h:27,
                 from net/ipv4/inetpeer.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/ipv4/protocol.c:36:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_sl82c105.c:22:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/ipv4/route.c:80:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from include/linux/tifm.h:19,
                 from drivers/memstick/host/tifm_ms.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from net/core/dev.c:91:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from include/linux/if_arp.h:27,
                 from net/decnet/dn_neigh.c:31:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/char/cs5535_gpio.c:20:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from include/linux/tifm.h:19,
                 from drivers/misc/tifm_core.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/decnet/dn_dev.c:33:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from include/linux/inetdevice.h:9,
                 from net/ipv4/ip_input.c:129:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/acpi/pci_link.c:41:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/ata/pata_opti.c:30:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/ipv4/ip_fragment.c:29:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/pci/access.c:3:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from drivers/pnp/core.c:17:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/core/ethtool.c:20:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from net/core/dev_mcast.c:38:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/core/skbuff.c:48:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/net/atl1e/atl1e_hw.c:22:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/ipv4/ip_forward.c:25:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from drivers/pnp/card.c:12:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/memstick/host/jmb38x_ms.c:15:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/misc/ioc4.c:31:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/net/atl1e/atl1e.h:32,
                 from drivers/net/atl1e/atl1e_main.c:23:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/core/dst.c:16:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from drivers/net/atl1e/atl1e_ethtool.c:24:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/lapb/lapb_in.c:29:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/pci/bus.c:13:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/lapb/lapb_timer.c:29:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from drivers/net/e1000e/82571.c:44:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/lapb/lapb_subr.c:27:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/ipv4/ip_options.c:17:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/lapb/lapb_out.c:28:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from include/linux/rtnetlink.h:5,
                 from net/core/netevent.c:17:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/decnet/dn_timer.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from drivers/net/e1000e/ich8lan.c:50:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:97,
                 from include/linux/pci.h:990,
                 from drivers/pnp/resource.c:18:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from net/decnet/dn_fib.c:26:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/netlink.h:156,
                 from net/decnet/dn_rules.c:21:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from net/core/neighbour.c:23:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
In file included from include/linux/dma-mapping.h:53,
                 from include/linux/dmaengine.h:30,
                 from include/linux/skbuff.h:30,
                 from include/linux/if_ether.h:115,
                 from include/linux/netdevice.h:30,
                 from include/net/sock.h:50,
                 from include/net/inet_sock.h:26,
                 from include/net/inet_connection_sock.h:24,
                 from net/ipv4/inet_hashtables.c:23:
include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
