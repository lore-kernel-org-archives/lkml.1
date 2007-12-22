Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXLVHdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXLVHdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 02:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXLVHcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 02:32:51 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45893 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXLVHcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 02:32:50 -0500
Message-ID: <476CBD9B.9070203@linux.vnet.ibm.com>
Date: Sat, 22 Dec 2007 13:02:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] Memory controller remove control_type feature
References: <20071220185358.3248.25416.sendpatchset@balbir-laptop> <20071221225941.98b7362d.akpm@linux-foundation.org>
In-Reply-To: <20071221225941.98b7362d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 21 Dec 2007 00:23:58 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Based on the discussion at http://lkml.org/lkml/2007/12/20/383, it was
>> felt that control_type might not be a good thing to implement right away.
>> We can add this flexibility at a later point when required.
> 
> Gee the memory controller patchset is turning into a mess.
> 

Yes, the patchset has expanded and we have several useful bug fixes and
cleanups and some new features.

> memory-controller-add-documentation.patch
> memcgroup-temporarily-revert-swapoff-mod.patch
> memory-controller-resource-counters-v7.patch
> memory-controller-containers-setup-v7.patch
> memory-controller-accounting-setup-v7.patch
> memory-controller-memory-accounting-v7.patch
> memory-controller-memory-accounting-v7-move-page_assign_page_cgroup-to-vm_bug_on-in-free_hot_cold_page.patch
> memory-controller-task-migration-v7.patch
> memory-controller-add-per-container-lru-and-reclaim-v7.patch
> memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
> memory-controller-improve-user-interface.patch
> memory-controller-improve-user-interface-memory-controller-enhancements-for-reclaiming-take2-possible-race-fix-in-res_counter.patch
> memory-controller-oom-handling-v7.patch
> memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
> memory-controller-make-page_referenced-container-aware-v7.patch
> memory-controller-make-charging-gfp-mask-aware.patch
> memory-controller-make-charging-gfp-mask-aware-fix.patch
> memcgroup-reinstate-swapoff-mod.patch
> memory-controller-bug_on.patch
> mem-controller-gfp-mask-fix.patch
> memcontrol-move-mm_cgroup-to-header-file.patch
> memcontrol-move-oom-task-exclusion-to-tasklist.patch
> oom-add-sysctl-to-enable-task-memory-dump.patch
> kswapd-should-only-wait-on-io-if-there-is-io.patch
> bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
> bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
> bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
> bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
> bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
> memcgroup-fix-zone-isolation-oom.patch
> memcgroup-revert-swap_state-mods.patch
> bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
> #
> memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
> memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch
> memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
> memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
> memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
> memcgroup-tidy-up-mem_cgroup_charge_common.patch
> memcgroup-fix-hang-with-shmem-tmpfs.patch
> memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
> memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
> memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
> memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
> memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
> memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
> memory-cgroup-enhancements-add-memorystat-file.patch
> memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
> memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
> memory-cgroup-enhancements-add-pre_destroy-handler.patch
> memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
> #
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-clean-up-remove-unused-variable.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-add-bug_on-in-mem_cgroup_zoneinfo.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix-accounting-in-vmscanc-for-memory-controller.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch
> per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
> memory-controller-remove-control_type-feature.patch
> update-documentation-controller-memorytxt.patch
> 
> Hopefully it'll look a bit better once I do a big patch-folding but we
> still have patches interesecting everywhere and now we have patches which
> add a feature and later ones which take it away again.
> 

I think folding will help. I understand your concern w.r.t getting the
correct set of patches with a good changelog.

> But I don't think it's worth the time and risk of a huge
> rip-up-and-refactor.
> 

I agree, given the proximity of the new merge window for 2.6.25.  We
could review the patches after folding them and see how to consolidate
further in case the patches continue to look messy.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
