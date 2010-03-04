Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0CDRti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:49:38 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33157 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0CDRth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:49:37 -0500
Date: Thu, 4 Mar 2010 19:49:35 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB updates for 2.6.34-rc1
Message-ID: <alpine.DEB.2.00.1003041947070.22477@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the usual batch of slab allocator updates. The biggest change are 
the per-CPU patches from Christoph that have been brewing in linux-next 
for few months now.

                         Pekka

The following changes since commit eaa5eec739637f32f8733d528ff0b94fd62b1214:
   Linus Torvalds (1):
         Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab-for-linus

Christoph Lameter (5):
       SLUB: Use this_cpu operations in slub
       SLUB: Get rid of dynamic DMA kmalloc cache allocation
       SLUB: this_cpu: Remove slub kmem_cache fields
       SLUB: Make slub statistics use this_cpu_inc
       dma kmalloc handling fixes

David Rientjes (1):
       slub: remove impossible condition

Dmitry Monakhov (1):
       failslab: add ability to filter slab caches

Haicheng Li (1):
       slab: initialize unused alien cache entry as NULL at alloc_alien_cache().

Nick Piggin (1):
       slab: fix regression in touched logic

Pekka Enberg (1):
       Merge branches 'slab/cleanups', 'slab/failslab', 'slab/fixes' and 'slub/percpu' into slab-for-linus

Stephen Rothwell (1):
       SLUB: Fix per-cpu merge conflict

  Documentation/vm/slub.txt    |    1 +
  include/linux/fault-inject.h |    5 +-
  include/linux/slab.h         |    5 +
  include/linux/slub_def.h     |   27 ++--
  mm/failslab.c                |   18 ++-
  mm/slab.c                    |   13 +-
  mm/slub.c                    |  337 +++++++++++++-----------------------------
  7 files changed, 146 insertions(+), 260 deletions(-)
