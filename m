Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab0CAQef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:34:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0CAQed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:34:33 -0500
Date: Mon, 1 Mar 2010 13:34:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for 2.6.34
Message-ID: <20100301163405.GB8730@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.34

To receive the following updates:

Alexander Graf (23):
      KVM: powerpc: Move vector to irqprio resolving to separate function
      KVM: powerpc: Improve DEC handling
      KVM: powerpc: Remove AGGRESSIVE_DEC
      KVM: powerpc: Change maintainer
      KVM: PPC: Fix typo in rebolting code
      KVM: PPC: Enable lightweight exits again
      KVM: PPC: Use accessor functions for GPR access
      KVM: PPC: Add helpers for CR, XER
      KVM: PPC: Use PACA backed shadow vcpu
      KVM: PPC: Implement 'skip instruction' mode
      KVM: PPC: Get rid of unnecessary RFI
      KVM: PPC: Call SLB patching code in interrupt safe manner
      KVM: PPC: Emulate trap SRR1 flags properly
      KVM: PPC: Fix HID5 setting code
      KVM: PPC: Pass program interrupt flags to the guest
      KVM: PPC: Pass through program interrupts
      KVM: PPC: Make large pages work
      KVM: PPC: Export __giveup_vsx
      KVM: PPC: Add helper functions to call real mode loaders
      KVM: PPC: Add support for FPU/Altivec/VSX
      KVM: PPC: Fix initial GPR settings
      KVM: PPC: Keep SRR1 flags around in shadow_msr
      KVM: PPC: Move Shadow MSR calculation to function

Avi Kivity (41):
      KVM: MMU: Report spte not found in rmap before BUG()
      KVM: VMX: Move some cr[04] related constants to vmx.c
      KVM: Add accessor for reading cr4 (or some bits of cr4)
      KVM: VMX: Make guest cr4 mask more conservative
      KVM: VMX: When using ept, allow the guest to own cr4.pge
      KVM: VMX: Fold ept_update_paging_mode_cr4() into its caller
      KVM: Disentangle mmu notifiers and coalesced_mmio registration
      KVM: Add include guards for coalesced_mmio.h
      KVM: Remove ifdefs from mmu notifier initialization
      KVM: Add KVM_MMIO kconfig item
      KVM: Simplify coalesced mmio initialization
      KVM: Bump maximum vcpu count to 64
      KVM: Fill out ftrace exit reason strings
      KVM: avoid taking ioapic mutex for non-ioapic EOIs
      KVM: VMX: trace clts and lmsw instructions as cr accesses
      KVM: Replace read accesses of vcpu->arch.cr0 by an accessor
      KVM: VMX: Allow the guest to own some cr0 bits
      KVM: Lazify fpu activation and deactivation
      KVM: VMX: Give the guest ownership of cr0.ts when the fpu is active
      KVM: Set cr0.et when the guest writes cr0
      KVM: SVM: Fix SVM_CR0_SELECTIVE_MASK
      KVM: SVM: Initialize fpu_active in init_vmcb()
      KVM: SVM: Restore unconditional cr0 intercept under npt
      KVM: SVM: Selective cr0 intercept
      KVM: SVM: Lazy fpu with npt
      KVM: export <asm/hyperv.h>
      KVM: Allow kvm_load_guest_fpu() even when !vcpu->fpu_active
      KVM: Drop kvm_{load,put}_guest_fpu() exports
      KVM: Activate fpu on clts
      KVM: Add a helper for checking if the guest is in protected mode
      KVM: Move cr0/cr4/efer related helpers to x86.h
      KVM: Rename vcpu->shadow_efer to efer
      KVM: Optimize kvm_read_cr[04]_bits()
      KVM: trace guest fpu loads and unloads
      KVM: VMX: Pass cr0.mp through to the guest when the fpu is active
      KVM: Fix msr trace
      KVM: Trace failed msr reads and writes
      KVM: VMX: Wire up .fpu_activate() callback
      KVM: MMU: Add tracepoint for guest page aging
      KVM: Plan obsolescence of kernel allocated slots, paravirt mmu
      KVM: Convert kvm->requests_lock to raw_spinlock_t

Eddie Dong (1):
      KVM: x86: make double/triple fault promotion generic to all exceptions

Gleb Natapov (18):
      KVM: Add HYPER-V header file
      KVM: Implement bare minimum of HYPER-V MSRs
      KVM: Add HYPER-V apic access MSRs
      KVM: Implement NotifyLongSpinWait HYPER-V hypercall
      KVM: fix Hyper-V hypercall warnings and wrong mask value
      KVM: x86: fix checking of cr0 validity
      KVM: mark segments accessed on HW task switch
      KVM: x86 emulator: Add group8 instruction decoding
      KVM: x86 emulator: Add group9 instruction decoding
      KVM: x86 emulator: Add Virtual-8086 mode of emulation
      KVM: x86 emulator: fix memory access during x86 emulation
      KVM: x86 emulator: Check IOPL level during io instruction emulation
      KVM: x86 emulator: Fix popf emulation
      KVM: x86 emulator: Check CPL level during privilege instruction emulation
      KVM: x86 emulator: Add LOCK prefix validity checking
      KVM: x86 emulator: disallow opcode 82 in 64-bit mode
      KVM: x86 emulator: Forbid modifying CS segment register by mov instruction
      KVM: Fix segment descriptor loading

Gui Jianfeng (1):
      KVM: VMX: Remove redundant check in vm_need_virtualize_apic_accesses()

Jan Kiszka (7):
      KVM: VMX: Fix exceptions of mov to dr
      KVM: VMX: Fix emulation of DR4 and DR5
      KVM: VMX: Clean up DR6 emulation
      KVM: SVM: Clean up and enhance mov dr emulation
      KVM: SVM: Trap all debug register accesses
      KVM: VMX: Update instruction length on intercepted BP
      KVM: x86: Add KVM_CAP_X86_ROBUST_SINGLESTEP

Jochen Maes (1):
      KVM: Fix Codestyle in virt/kvm/coalesced_mmio.c

Joe Perches (1):
      KVM: ia64: Fix string literal continuation lines

Joerg Roedel (2):
      KVM: SVM: Adjust tsc_offset only if tsc_unstable
      KVM: Introduce kvm_host_page_size

Julia Lawall (1):
      KVM: VMX: Remove redundant test in vmx_set_efer()

Liu Yu (4):
      KVM: PPC E500: Add register l1csr0 emulation
      KVM: PPC: Add PVR/PIR init for E500
      KVM: PPC E500: fix tlbcfg emulation
      KVM: ppc/booke: Set ESR and DEAR when inject interrupt to guest

Marcelo Tosatti (13):
      KVM: x86: raise TSS exception for NULL CS and SS segments
      KVM: modify memslots layout in struct kvm
      KVM: modify alias layout in x86s struct kvm_arch
      KVM: split kvm_arch_set_memory_region into prepare and commit
      KVM: introduce gfn_to_pfn_memslot
      KVM: use gfn_to_pfn_memslot in kvm_iommu_map_pages
      KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU update
      KVM: use SRCU for dirty log
      KVM: x86: switch kvm_set_memory_alias to SRCU update
      KVM: convert io_bus to SRCU
      KVM: switch vcpu context to use SRCU
      KVM: convert slots_lock to a mutex
      KVM: fix cleanup_srcu_struct on vm destruction

Michael S. Tsirkin (1):
      KVM: do not store wqh in irqfd

Rik van Riel (1):
      KVM: VMX: emulate accessed bit for EPT

Roel Kluin (1):
      KVM: ia64: remove redundant kvm_get_exit_data() NULL tests

Sheng Yang (12):
      KVM: VMX: Trap and invalid MWAIT/MONITOR instruction
      KVM: VMX: Remove redundant variable
      KVM: Extended shared_msr_global to per CPU
      x86: Raise vsyscall priority on hotplug notifier chain
      KVM: Add cpuid_update() callback to kvm_x86_ops
      KVM: VMX: Add instruction rdtscp support for guest
      KVM: x86: Moving PT_*_LEVEL to mmu.h
      KVM: x86: Rename gb_page_enable() to get_lpage_level() in kvm_x86_ops
      KVM: VMX: Enable EPT 1GB page support
      KVM: VMX: Remove emulation failure report
      KVM: Fix kvm_coalesced_mmio_ring duplicate allocation
      KVM: VMX: Rename VMX_EPT_IGMT_BIT to VMX_EPT_IPAT_BIT

Takuya Yoshikawa (8):
      KVM: Fix the explanation of write_emulated
      KVM: rename is_writeble_pte() to is_writable_pte()
      KVM: x86: Use macros for x86_emulate_ops to avoid future mistakes
      KVM: fix load_guest_segment_descriptor() to return X86EMUL_*
      KVM: fix kvm_fix_hypercall() to return X86EMUL_*
      KVM: Remove redundant reading of rax on OUT instructions
      KVM: Fix load_guest_segment_descriptor() to inject page fault
      KVM: Fix emulate_sys[call, enter, exit]()'s fault handling

Thomas Gleixner (1):
      KVM: Convert i8254/i8259 locks to raw_spinlocks

Wei Yongjun (6):
      KVM: MMU: Remove some useless code from alloc_mmu_pages()
      KVM: PIT: unregister kvm irq notifier if fail to create pit
      KVM: kvm->arch.vioapic should be NULL if kvm_ioapic_init() failure
      KVM: cleanup the failure path of KVM_CREATE_IRQCHIP ioctrl
      KVM: ia64: destroy ioapic device if fail to setup default irq routing
      KVM: x86 emulator: code style cleanup

Wu Fengguang (1):
      KVM: trivial document fixes

Zhai, Edwin (1):
      KVM: enable PCI multiple-segments for pass-through device


 Documentation/feature-removal-schedule.txt   |   30 +
 Documentation/kvm/api.txt                    |   12 +-
 MAINTAINERS                                  |    2 +-
 arch/ia64/kvm/Kconfig                        |    1 +
 arch/ia64/kvm/kvm-ia64.c                     |   50 +-
 arch/ia64/kvm/kvm_fw.c                       |   28 +-
 arch/ia64/kvm/mmio.c                         |    4 +-
 arch/ia64/kvm/vcpu.c                         |    4 +-
 arch/powerpc/include/asm/kvm_asm.h           |    6 +
 arch/powerpc/include/asm/kvm_book3s.h        |   11 +-
 arch/powerpc/include/asm/kvm_book3s_64_asm.h |   18 +
 arch/powerpc/include/asm/kvm_e500.h          |    3 +
 arch/powerpc/include/asm/kvm_host.h          |   23 +-
 arch/powerpc/include/asm/kvm_ppc.h           |   83 ++-
 arch/powerpc/include/asm/paca.h              |    5 +
 arch/powerpc/include/asm/reg.h               |    4 +
 arch/powerpc/kernel/asm-offsets.c            |   33 +-
 arch/powerpc/kernel/ppc_ksyms.c              |    1 +
 arch/powerpc/kvm/44x_emulate.c               |   25 +-
 arch/powerpc/kvm/44x_tlb.c                   |   20 +-
 arch/powerpc/kvm/Kconfig                     |    1 +
 arch/powerpc/kvm/book3s.c                    |  309 ++++++--
 arch/powerpc/kvm/book3s_64_emulate.c         |   77 +-
 arch/powerpc/kvm/book3s_64_exports.c         |    8 +
 arch/powerpc/kvm/book3s_64_interrupts.S      |  336 +++-----
 arch/powerpc/kvm/book3s_64_mmu.c             |   10 +-
 arch/powerpc/kvm/book3s_64_rmhandlers.S      |  119 +++-
 arch/powerpc/kvm/book3s_64_slb.S             |  160 +++--
 arch/powerpc/kvm/booke.c                     |   87 ++-
 arch/powerpc/kvm/booke_emulate.c             |  107 ++--
 arch/powerpc/kvm/e500.c                      |    6 +
 arch/powerpc/kvm/e500_emulate.c              |   93 ++--
 arch/powerpc/kvm/e500_tlb.c                  |   10 +-
 arch/powerpc/kvm/emulate.c                   |  118 ++--
 arch/powerpc/kvm/powerpc.c                   |   40 +-
 arch/s390/kvm/kvm-s390.c                     |   26 +-
 arch/s390/kvm/kvm-s390.h                     |   10 +-
 arch/x86/include/asm/Kbuild                  |    1 +
 arch/x86/include/asm/hyperv.h                |  186 +++++
 arch/x86/include/asm/kvm_emulate.h           |   17 +-
 arch/x86/include/asm/kvm_host.h              |   60 +-
 arch/x86/include/asm/kvm_para.h              |    1 +
 arch/x86/include/asm/svm.h                   |    2 +-
 arch/x86/include/asm/vmx.h                   |    5 +-
 arch/x86/kernel/vsyscall_64.c                |    3 +-
 arch/x86/kvm/Kconfig                         |    1 +
 arch/x86/kvm/emulate.c                       |  440 +++++++----
 arch/x86/kvm/i8254.c                         |   23 +-
 arch/x86/kvm/i8254.h                         |    2 +-
 arch/x86/kvm/i8259.c                         |   46 +-
 arch/x86/kvm/irq.h                           |    3 +-
 arch/x86/kvm/kvm_cache_regs.h                |   31 +
 arch/x86/kvm/lapic.c                         |   31 +
 arch/x86/kvm/lapic.h                         |    8 +
 arch/x86/kvm/mmu.c                           |  137 ++--
 arch/x86/kvm/mmu.h                           |   35 +-
 arch/x86/kvm/paging_tmpl.h                   |   13 +-
 arch/x86/kvm/svm.c                           |  237 ++++---
 arch/x86/kvm/trace.h                         |   59 ++-
 arch/x86/kvm/vmx.c                           |  396 +++++++---
 arch/x86/kvm/x86.c                           | 1098 +++++++++++++++++++-------
 arch/x86/kvm/x86.h                           |   30 +
 include/linux/kvm.h                          |   10 +-
 include/linux/kvm_host.h                     |   71 +-
 include/trace/events/kvm.h                   |   41 +
 virt/kvm/Kconfig                             |    3 +
 virt/kvm/assigned-dev.c                      |   12 +-
 virt/kvm/coalesced_mmio.c                    |   43 +-
 virt/kvm/coalesced_mmio.h                    |   15 +
 virt/kvm/eventfd.c                           |   21 +-
 virt/kvm/ioapic.c                            |   38 +-
 virt/kvm/ioapic.h                            |    2 +
 virt/kvm/iommu.c                             |   36 +-
 virt/kvm/kvm_main.c                          |  392 ++++++----
 74 files changed, 3768 insertions(+), 1661 deletions(-)


