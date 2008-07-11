Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbYGKT14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbYGKT14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYGKT1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:27:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYGKT1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:27:47 -0400
Date: Fri, 11 Jul 2008 21:27:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86/pci: Renaming numa into numaq
Message-ID: <20080711192733.GA32623@elte.hu>
References: <1215771521-6848-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215771521-6848-1-git-send-email-robert.richter@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> This patch series renames numa into numaq for x86/pci code.

applied to tip/x86/unify-pci:

  Robert Richter (5):
       x86/pci: Removing pci-y in Makefile
       x86/pci: Changing subsystem initialization order for NUMA
       x86/pci: renamed: numa.c -> numaq_32.c
       x86/pci: renaming numa into numaq
       x86/pci: Changing subsystem init for visws

thanks Robert.

Jesse, do you give us a general Ack for this direction and these 
commits? The changes are way too intermixed with other x86 bits to be 
cleanly separable at this stage, so it would be nice if we merged this 
via the x86 tree. Find below a list of commit IDs that change 
arch/x86/pci/ - all but the last few ones are in linux-next as well.

	Ingo

3cabf37: x86/pci: Changing subsystem init for visws
e27cf3a: x86/pci: renaming numa into numaq
9314d30: x86/pci: renamed: numa.c -> numaq_32.c
060b970: x86/pci: Changing subsystem initialization order for NUMA
2510495: x86/pci: Removing pci-y in Makefile
f361a45: x86: introduce max_low_pfn_mapped for 64-bit
3a62ed7: x86/pci: fix warnings in subsys_initcall functions
3f68f7d: x86/pci merge: fixing numaq initialization
62fa572: x86, VisWS: turn into generic arch, remove leftover files
b4b8641: x86, VisWS: turn into generic arch, create include/asm-x86/visws/
5548ed1: x86, VisWS: turn into generic arch, install proper PCI quirk
31ac409: x86, VisWS: turn into generic arch, add early init quirks
22d5c67: x86, VisWS: turn into generic arch, make VisWS boot on a regular PC
8dd779b: x86/pci: removing subsys_initcall ordering dependencies
ae28d70: x86/pci: visws: renaming pcibios_init()
f4d994b: x86/pci: Makefile merge: coalescing 32 and 64 bit
d199a04: x86/pci: merge: moving mp_bus_to_node.c to amd_bus.c
42a4b42: x86/pci: mp_bus_to_node merge: moving code in amd_bus.c
8eefc66: x86/pci: Makefile merge: creating pci-y for 64 bit
8043c7b: x86/pci: Makefile merge: changing 64bit ordering
a5d4fb9: x86/pci: Makefile merge: decoupling options for mp_bus_to_node.o
0b40e84: x86/pci: Makefile merge: whitespace changes only
7fa71c0: x86/pci: Makefile merge: removing include dir flag
6d8566a: x86/pci: Makefile merge: Removing Makefile_*
9197979: x86, pci: introduce pci=ioapicreroute kernel cmdline option
a9322f6: x86, pci: introduce pci=noioapicquirk kernel cmdline option
7d5e406: generic-ipi: x86-tree merge fixes
dbb6152: x86: don't call pxm_to_node again
b755de8: x86: make dev_to_node return online node
0715650: x86: move pci_routirq declaration to pci.h
3a27dd1: x86: Move PCI IO ECS code to x86/pci
24bfdca: x86/pci: Renaming k8-bus_64.c to amd_bus.c
499f8f8: x86: rename pat_wc_enabled to pat_enabled
7058b06: x86: coding style fixes to arch/x86/pci/irq.
d49c428: x86: make generic arch support NUMAQ
831d991: x86: add PCI extended config space access for AMD Barcelona
8004dd9: x86: amd opteron TOM2 mask val fix
968cbfa: x86: make __pci_mmcfg_init static in mmconfig-shared.c
