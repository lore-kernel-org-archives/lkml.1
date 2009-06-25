Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZFYBWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZFYBWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 21:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZFYBWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 21:22:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbZFYBWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 21:22:20 -0400
Date: Wed, 24 Jun 2009 20:11:37 -0400
From: Dave Jones <davej@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kmemleak false positive?
Message-ID: <20090625001137.GB22755@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During boot, I see the following traces from kmemleak.
They seem to be pointing at kmemleak itself. False positive?

(this is in -git22)

	Dave


kmemleak: unreferenced object 0xdb804000 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804040 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804080 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8040c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804100 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804140 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804180 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8041c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804200 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804240 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804280 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8042c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804300 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804340 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804380 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8043c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804400 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804440 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804480 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8044c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804500 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804540 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804580 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8045c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804600 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804640 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804680 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8046c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804700 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804740 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804780 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8047c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804800 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804840 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804880 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8048c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804900 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804940 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804980 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb8049c0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804a00 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804a40 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804a80 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804ac0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804b00 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804b40 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804b80 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804bc0 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804c00 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff
kmemleak: unreferenced object 0xdb804c40 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff

