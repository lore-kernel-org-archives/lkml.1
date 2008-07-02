Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYGBTmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYGBTmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYGBTmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:42:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbYGBTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:42:36 -0400
Date: Wed, 2 Jul 2008 12:40:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: torvalds@linux-foundation.org, clameter@sgi.com, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm@vger.kernel.org, kanojsarcar@yahoo.com, rdreier@cisco.com,
       swise@opengridcomputing.com, linux-kernel@vger.kernel.org,
       avi@qumranet.com, linux-mm@kvack.org, general@lists.openfabrics.org,
       hugh@veritas.com, rusty@rustcorp.com.au, aliguori@us.ibm.com,
       chrisw@redhat.com, marcelo@kvack.org, dada1@cosmosbay.com,
       paulmck@us.ibm.com, izike@qumranet.com, riel@redhat.com,
       andrea@qumranet.com, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0 of 3] mmu notifier v18 for -mm
Message-Id: <20080702124002.6d899621.akpm@linux-foundation.org>
In-Reply-To: <patchbomb.1214440016@duo.random>
References: <patchbomb.1214440016@duo.random>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I merged the mmu-notifers patches ahead of these:

#
# gup
#
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
#
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
#mm-speculative-page-references.patch: clameter saw bustage
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-hugh-fix3.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
#
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
more-aggressively-use-lumpy-reclaim.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-kconfig-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
swap-cull-unevictable-pages-in-fault-path.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
vmscam-kill-unused-lru-functions.patch

with a view to merging the mmu-notifiers patches into 2.6.27-rc1.  I
expect that the above patches are 2.6.28 material.


Consequently some of the above patches needed some rework which should
be checked, please.  In particular, do the above patches add new code
which needs mmu-notifier treatment?

Patches which actually required reject fixing were:

unevictable-lru-infrastructure.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
swap-cull-unevictable-pages-in-fault-path.patch

but really the whole MM needs reviewing to check that the
post-mmu-motifiers changes didn't break mmu notifiers.  We have about
three months in which to get that done.
