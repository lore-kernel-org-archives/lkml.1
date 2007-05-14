Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbXENOt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbXENOt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXENOtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:49:52 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34093 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbXENOtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:49:51 -0400
X-Greylist: delayed 1769 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2007 10:49:51 EDT
Date: Mon, 14 May 2007 17:20:20 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: ppc modprost warnings in 2.6.22-rc1
Message-ID: <Pine.SOC.4.64.0705141717110.23895@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to compile 2.6.22-rc1 for ppc (prep) arch. While section 
mismatches are an old thing, what are these COMMON symbols?

  MODPOST vmlinux
WARNING: "fee_restarts" [arch/ppc/kernel/built-in] is COMMON symbol
WARNING: "ee_restarts" [arch/ppc/kernel/built-in] is COMMON symbol
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x18) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x3c) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x114) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x138) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x15c) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x180) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x1a4) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x1c8) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x1ec) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x210) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x234) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x258) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x27c) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x2a0) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x2c4) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x2e8) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x30c) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x330) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x354) and 'Mesquite_pci_IRQ_map'
WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x378) and 'Mesquite_pci_IRQ_map'
WARNING: "primary_pteg_full" [arch/ppc/mm/built-in] is COMMON symbol
WARNING: "next_slot" [arch/ppc/mm/built-in] is COMMON symbol
WARNING: "htab_hash_searches" [arch/ppc/mm/built-in] is COMMON symbol
WARNING: arch/ppc/mm/built-in.o - Section mismatch: reference to .init.text:early_get_page from .text between 'pte_alloc_one_kernel' (at offset 0x1168) and 'hash_page'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x24208) and 'kmem_cache_shrink'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x24350) and 'kmem_cache_shrink'
WARNING: lib/built-in: '__div64_32' exported twice. Previous export was in arch/ppc/kernel/built-in.ko


-- 
Meelis Roos (mroos@linux.ee)
