Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZDGNLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZDGNLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZDGNLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:11:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37434 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbZDGNLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:11:05 -0400
Subject: Next April 7 : x86_64 randconfig failure
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: linux-next <linux-next@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Alexander Beregalov <a.beregalov@gmail.com>
In-Reply-To: <1239106436.5300.33.camel@subratamodak.linux.ibm.com>
References: <1239106436.5300.33.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Tue, 07 Apr 2009 18:41:01 +0530
Message-Id: <1239109861.11996.0.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another error observed:

arch/x86/kernel/built-in.o: In function `lapic_suspend':
apic.c:(.text+0x16586): undefined reference to `intr_remapping_enabled'
apic.c:(.text+0x1658e): undefined reference to `disable_intr_remapping'
arch/x86/kernel/built-in.o: In function `lapic_resume':
apic.c:(.text+0x168ac): undefined reference to `intr_remapping_enabled'
apic.c:(.text+0x168b9): undefined reference to `reenable_intr_remapping'
arch/x86/kernel/built-in.o: In function `set_ioapic_affinity_irq_desc':
io_apic.c:(.text+0x18c77): undefined reference to `irq_remapped'
arch/x86/kernel/built-in.o: In function
`set_ir_ioapic_affinity_irq_desc':
io_apic.c:(.text+0x19402): undefined reference to `get_irte'
io_apic.c:(.text+0x19453): undefined reference to `modify_irte'
arch/x86/kernel/built-in.o: In function `destroy_irq':
(.text+0x1951b): undefined reference to `free_irte'
arch/x86/kernel/built-in.o: In function `disable_IO_APIC':
(.text+0x198a3): undefined reference to `intr_remapping_enabled'
arch/x86/kernel/built-in.o: In function `disable_IO_APIC':
(.text+0x198df): undefined reference to `intr_remapping_enabled'
arch/x86/kernel/built-in.o: In function `setup_ioapic_entry':
(.text+0x19951): undefined reference to `intr_remapping_enabled'
arch/x86/kernel/built-in.o: In function `setup_ioapic_entry':
(.text+0x19974): undefined reference to `map_ioapic_to_ir'
arch/x86/kernel/built-in.o: In function `setup_ioapic_entry':
(.text+0x19995): undefined reference to `alloc_irte'
arch/x86/kernel/built-in.o: In function `setup_ioapic_entry':
(.text+0x19a06): undefined reference to `modify_irte'
arch/x86/kernel/built-in.o: In function `setup_IO_APIC_irq':
io_apic.c:(.text+0x19c23): undefined reference to `irq_remapped'
arch/x86/kernel/built-in.o: In function `pci_iommu_init':
pci-dma.c:(.init.text+0x312c): undefined reference to
`dmar_dev_scope_init'
arch/x86/kernel/built-in.o: In function `pci_iommu_alloc':
(.init.text+0x31ac): undefined reference to `detect_intel_iommu'
arch/x86/kernel/built-in.o: In function `enable_IR_x2apic':
(.init.text+0x8de4): undefined reference to `dmar_table_init'
arch/x86/kernel/built-in.o: In function `enable_IR_x2apic':
(.init.text+0x8e73): undefined reference to `enable_intr_remapping'
arch/x86/kernel/built-in.o: In function `default_setup_apic_routing':
(.init.text+0x9512): undefined reference to `intr_remapping_enabled'
arch/x86/kernel/built-in.o: In function `default_setup_apic_routing':
(.init.text+0x951a): undefined reference to `enable_drhd_fault_handling'
arch/x86/kernel/built-in.o: In function `setup_timer_IRQ0_pin':
io_apic.c:(.init.text+0xab52): undefined reference to
`intr_remapping_enabled'
arch/x86/kernel/built-in.o: In function `setup_ioapic_dest':
(.init.text+0xadbf): undefined reference to `intr_remapping_enabled'
arch/x86/kernel/built-in.o: In function `setup_IO_APIC':
(.init.text+0xb1b6): undefined reference to `intr_remapping_enabled'
arch/x86/kernel/built-in.o: In function `setup_IO_APIC':
(.init.text+0xb294): undefined reference to `intr_remapping_enabled'
make: *** [.tmp_vmlinux1] Error 1

Regards--
Subrata

On Tue, 2009-04-07 at 17:44 +0530, Subrata Modak wrote:
> Hi,
> 
> Reporting another build error for x86_64 with April 07 next tree
> configured for randconfig.
> 
> aicasm_symbol.c:48:19: error: aicdb.h: No such file or directory
> aicasm_symbol.c:63: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
> ‘__attribute__’ before ‘*’ token
> aicasm_symbol.c: In function ‘symbol_delete’:
> aicasm_symbol.c:87: error: ‘symtable’ undeclared (first use in this
> function)
> aicasm_symbol.c:87: error: (Each undeclared identifier is reported only
> once
> aicasm_symbol.c:87: error: for each function it appears in.)
> aicasm_symbol.c:88: error: ‘DBT’ undeclared (first use in this function)
> aicasm_symbol.c:88: error: expected ‘;’ before ‘key’
> aicasm_symbol.c:90: error: ‘key’ undeclared (first use in this function)
> aicasm_symbol.c: In function ‘symtable_open’:
> aicasm_symbol.c:134: error: ‘symtable’ undeclared (first use in this
> function)
> aicasm_symbol.c:135: error: ‘DB_HASH’ undeclared (first use in this
> function)
> aicasm_symbol.c: In function ‘symtable_close’:
> aicasm_symbol.c:148: error: ‘symtable’ undeclared (first use in this
> function)
> aicasm_symbol.c:149: error: ‘DBT’ undeclared (first use in this
> function)
> aicasm_symbol.c:149: error: expected ‘;’ before ‘key’
> aicasm_symbol.c:150: error: expected ‘;’ before ‘data’
> aicasm_symbol.c:152: error: ‘key’ undeclared (first use in this
> function)
> aicasm_symbol.c:152: error: ‘data’ undeclared (first use in this
> function)
> aicasm_symbol.c:152: error: ‘R_FIRST’ undeclared (first use in this
> function)
> aicasm_symbol.c: In function ‘symtable_get’:
> aicasm_symbol.c:170: error: ‘DBT’ undeclared (first use in this
> function)
> aicasm_symbol.c:170: error: expected ‘;’ before ‘key’
> aicasm_symbol.c:171: error: expected ‘;’ before ‘data’
> aicasm_symbol.c:174: error: ‘key’ undeclared (first use in this
> function)
> aicasm_symbol.c:177: error: ‘symtable’ undeclared (first use in this
> function)
> aicasm_symbol.c:177: error: ‘data’ undeclared (first use in this
> function)
> aicasm_symbol.c: In function ‘symtable_dump’:
> aicasm_symbol.c:479: error: ‘DBT’ undeclared (first use in this
> function)
> aicasm_symbol.c:479: error: expected ‘;’ before ‘key’
> aicasm_symbol.c:480: error: expected ‘;’ before ‘data’
> aicasm_symbol.c:485: error: ‘symtable’ undeclared (first use in this
> function)
> aicasm_symbol.c:494: error: ‘R_FIRST’ undeclared (first use in this
> function)
> aicasm_symbol.c:495: error: ‘key’ undeclared (first use in this
> function)
> aicasm_symbol.c:495: error: ‘data’ undeclared (first use in this
> function)
> aicasm_symbol.c:532: error: ‘R_NEXT’ undeclared (first use in this
> function)
> make[4]: *** [aicasm] Error 1
> make[3]: *** [drivers/scsi/aic7xxx/aicasm/aicasm] Error 2
> make[2]: *** [drivers/scsi/aic7xxx] Error 2
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> 
> Regards--
> Subrata
> 

