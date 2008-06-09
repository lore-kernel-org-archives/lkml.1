Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYFIVoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYFIVoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYFIVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:44:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:63543 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYFIVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SRUI8VQBjcU7X+ZsvE7K6BMWF74vpFDt6DVIagEs3fJamW8xWnV3fCyISBXE1Sxb5Z
         XbMh57Fhi9jwwr1LYdnUrpSVYIs0WLqijvw1aFks6hML1aKu0Hi+hZC8iuuxT2tpQMlB
         GLJNTmWRQ4PrK/REBFVcYI8xpyKmBlbRoFXR0=
Date: Tue, 10 Jun 2008 01:40:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm1: kernel BUG at mm/filemap.c:575!
Message-ID: <20080609214002.GA4932@martell.zuzino.mipt.ru>
References: <20080609053908.8021a635.akpm@linux-foundation.org> <20080609204559.GA4863@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609204559.GA4863@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 12:45:59AM +0400, Alexey Dobriyan wrote:
> This happened after LTP run finished.
> 
> ------------[ cut here ]------------
> kernel BUG at mm/filemap.c:575!

Easily reproducible and .config snippets:

CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_SWAP=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y

# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SLABINFO=y
CONFIG_SMP=y
CONFIG_X86_PC=y
CONFIG_MCORE2=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=2
CONFIG_SCHED_MC=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_RCU=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xffffc10000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_NORECLAIM_LRU is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y

CONFIG_EXT3_FS=y
CONFIG_JBD=y
CONFIG_TMPFS=y

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_SLUB_DEBUG_ON=y
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_FRAME_POINTER=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_RODATA=y

