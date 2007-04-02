Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbXDBF7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbXDBF7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933634AbXDBF7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:59:07 -0400
Received: from gw.goop.org ([64.81.55.164]:38245 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXDBF7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:59:03 -0400
Message-Id: <20070402055652.610711908@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 01 Apr 2007 22:56:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 00/17] paravirt_ops updates
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This series of patches updates paravirt_ops in various ways.  Some of the
changes are plain cleanups and improvements, and some add some interfaces
necessary for Xen.

The brief overview:

add-MAINTAINERS.patch			- obvious
remove-CONFIG_DEBUG_PARAVIRT.patch	- no longer needed
paravirt-nop.patch			- mark nop operations consistently
paravirt-pte-accessors.patch		- operations to pack/unpack ptes
paravirt-memory-init.patch		- hooks for memory/pagetable init
paravirt-fixmap.patch			- add fixmap for paravirt boot
shared-kernel-pmd.patch			- allow selectable shared kernel pmd
mm-lifetime-hooks.patch			- hooks for mm dup/activate/exit
paravirt-patch-rename-paravirt_patch.patch - rename patch structure for clarity
paravirt-use-offset-site-ids.patch	- use patch-site id derived from offset
paravirt-fix-clobbers.patch		- fix register clobbers for patch sites
paravirt-patchable-call-wrappers.patch	- wrap paravirt calls for patching
paravirt-patch-machinery.patch		- common patch machinery
paravirt-flush_tlb_others.patch		- paravirt hook for cross-cpu tlb flushing
revert-map_pt_hook.patch		- back out map_pt_hook
paravirt-kmap_atomic_pte.patch		- add kmap_atomic_pte for highpte
paravirt-sched-clock.patch		- hook to measure schedulable time

Thanks,
	J

-- 

