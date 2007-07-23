Return-Path: <linux-kernel-owner+w=401wt.eu-S933825AbXGWCuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbXGWCuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 22:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbXGWCu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 22:50:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:12178 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbXGWCu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 22:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=o13wYtcZFCEAydKChF7FmrUz4Sg+khuGBd7Mzkjc7FM9Xul18AsntGp0C5XpE8FlY+JvtB01FrlVxcdyfc9kzhfINpAU3Yasn1ex+PI4Jxe6zJq8y41/jQ5COS0RYbpsa46Jv8yGyMFU4JzYKx4qmhjJX27w/b84Ee7XLIWPq+4=
Message-ID: <46A416E1.80303@googlemail.com>
Date: Mon, 23 Jul 2007 04:48:01 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.23-rc1
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

allyesconfig has a lot 'Section mismatch' warnings 


...


  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x183): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux.o(.data+0x4b38): Section mismatch: reference to .init.text.3:powernow_cpu_init (between 'powernow_driver' and 'minimum_speed')
WARNING: vmlinux.o(.data+0x4c2c): Section mismatch: reference to .init.text.3:longhaul_cpu_init (between 'longhaul_driver' and 'numscales')
WARNING: vmlinux.o(.data+0x4cf4): Section mismatch: reference to .init.text.3:longrun_cpu_init (between 'longrun_driver' and 'max_duration')
WARNING: vmlinux.o(.data+0x57f4): Section mismatch: reference to .init.text.3:native_smp_prepare_boot_cpu (between 'smp_ops' and 'call_lock')
WARNING: vmlinux.o(.data+0x57f8): Section mismatch: reference to .init.text.3:native_smp_prepare_cpus (between 'smp_ops' and 'call_lock')
WARNING: vmlinux.o(.data+0x5800): Section mismatch: reference to .init.text.3:native_smp_cpus_done (between 'smp_ops' and 'call_lock')
WARNING: vmlinux.o(.data+0x6c00): Section mismatch: reference to .init.text.5:machine_specific_memory_setup (between 'paravirt_ops' and 'reserve_ioports')
WARNING: vmlinux.o(.data+0x6c08): Section mismatch: reference to .init.text.3:native_init_IRQ (between 'paravirt_ops' and 'reserve_ioports')
WARNING: vmlinux.o(.data+0x6c0c): Section mismatch: reference to .init.text.3:hpet_time_init (between 'paravirt_ops' and 'reserve_ioports')
WARNING: vmlinux.o(.data+0x6c10): Section mismatch: reference to .init.text.4:native_pagetable_setup_start (between 'paravirt_ops' and 'reserve_ioports')
WARNING: vmlinux.o(.data+0x6c14): Section mismatch: reference to .init.text.4:native_pagetable_setup_done (between 'paravirt_ops' and 'reserve_ioports')
WARNING: vmlinux.o(.data+0x6c18): Section mismatch: reference to .init.text.3:default_banner (between 'paravirt_ops' and 'reserve_ioports')
WARNING: vmlinux.o(.data+0x6cdc): Section mismatch: reference to .init.text.3:setup_boot_APIC_clock (between 'paravirt_ops' and 'reserve_ioports')
WARNING: vmlinux.o(.data+0x9b43c): Section mismatch: reference to .init.text.19:arcfb_probe (between 'arcfb_driver' and 'arcfb_ops')
WARNING: vmlinux.o(.data+0xa0950): Section mismatch: reference to .init.text.19:gx1fb_probe (between 'gx1fb_driver' and 'gx1fb_ops')
WARNING: vmlinux.o(.data+0xa0b98): Section mismatch: reference to .init.text.19:gxfb_probe (between 'gxfb_driver' and 'gxfb_ops')
WARNING: vmlinux.o(.data+0xa2c58): Section mismatch: reference to .init.text.19:hgafb_probe (between 'hgafb_driver' and 'hgafb_device')
WARNING: vmlinux.o(.data+0xa3798): Section mismatch: reference to .init.text.19:sm501fb_probe (between 'sm501fb_driver' and 'dev_attr_fbregs_crt')
WARNING: vmlinux.o(.data+0xa39e4): Section mismatch: reference to .init.text.19:vesafb_probe (between 'vesafb_driver' and 'vesafb_ops')
WARNING: vmlinux.o(.data+0xa3b50): Section mismatch: reference to .init.text.19:imacfb_probe (between 'imacfb_driver' and 'imacfb_device')
WARNING: vmlinux.o(.data+0xa3ed4): Section mismatch: reference to .init.text.19:vga16fb_probe (between 'vga16fb_driver' and 'vga16fb_ops')
WARNING: vmlinux.o(.data+0xa4040): Section mismatch: reference to .init.text.19:vfb_probe (between 'vfb_driver' and 'vfb_ops')
WARNING: vmlinux.o(.data+0xaf038): Section mismatch: reference to .init.text.19:hvc_console_setup (between 'hvc_con_driver' and 'vtermnos')
WARNING: vmlinux.o(.data+0xc22e0): Section mismatch: reference to .init.text.19:serial8250_console_setup (between 'serial8250_console' and 'serial8250_reg')
WARNING: vmlinux.o(.data+0xc22e4): Section mismatch: reference to .init.text.19:serial8250_console_early_setup (between 'serial8250_console' and 'serial8250_reg')
WARNING: vmlinux.o(.data+0xc9fb0): Section mismatch: reference to .init.text.19:cpqarray_init_one (between 'cpqarray_pci_driver' and 'ida_fops')
WARNING: vmlinux.o(.data+0xd7b38): Section mismatch: reference to .init.text.19:dgrs_eisa_probe (between 'dgrs_eisa_driver' and 'dgrs_pci_driver')
WARNING: vmlinux.o(.data+0xd7b5c): Section mismatch: reference to .init.text.19:dgrs_pci_probe (between 'dgrs_pci_driver' and '__param_str_nicmode')
WARNING: vmlinux.o(.data+0xd83c8): Section mismatch: reference to .init.text.19:vortex_eisa_probe (between 'vortex_eisa_driver' and '__param_str_use_mmio')
WARNING: vmlinux.o(.data+0x10ea34): Section mismatch: reference to .init.text.19:hp100_eisa_probe (between 'hp100_eisa_driver' and 'hp100_pci_driver')
WARNING: vmlinux.o(.data+0x10eee8): Section mismatch: reference to .init.text.19:ultramca_probe (between 'ultra_driver' and '__param_str_ultra_irq')
WARNING: vmlinux.o(.data+0x10f048): Section mismatch: reference to .init.text.19:ne3210_eisa_probe (between 'ne3210_eisa_driver' and 'ne3210_ids')
WARNING: vmlinux.o(.data+0x110f14): Section mismatch: reference to .init.text.19:el3_eisa_probe (between 'el3_eisa_driver' and 'el3_mca_driver')
WARNING: vmlinux.o(.data+0x111010): Section mismatch: reference to .init.text.19:el3_mca_probe (between 'el3_mca_driver' and '__param_str_nopnp')
WARNING: vmlinux.o(.data+0x111af4): Section mismatch: reference to .init.text.19:depca_mca_probe (between 'depca_mca_driver' and 'depca_eisa_driver')
WARNING: vmlinux.o(.data+0x111be8): Section mismatch: reference to .init.text.19:depca_eisa_probe (between 'depca_eisa_driver' and 'depca_isa_driver')
WARNING: vmlinux.o(.data+0x111bfc): Section mismatch: reference to .init.text.19:depca_isa_probe (between 'depca_isa_driver' and 'depca_string')
WARNING: vmlinux.o(.data+0x12f4fc): Section mismatch: reference to .init.text.19:de4x5_eisa_probe (between 'de4x5_eisa_driver' and 'version')
WARNING: vmlinux.o(.data+0x13328c): Section mismatch: reference to .init.text.19:smsc_ircc_pnp_probe (between 'smsc_ircc_pnp_driver' and '__param_str_ircc_transceiver')
WARNING: vmlinux.o(.data+0x1a4360): Section mismatch: reference to .init.text.19:sim710_mca_probe (between 'sim710_mca_driver' and 'sim710_eisa_driver')
WARNING: vmlinux.o(.data+0x1a4454): Section mismatch: reference to .init.text.19:sim710_eisa_probe (between 'sim710_eisa_driver' and 'sim710_mca_id_table')
WARNING: vmlinux.o(.data+0x1a454c): Section mismatch: reference to .init.text.19:advansys_detect (between 'driver_template' and '_asc_mcode_buf')
WARNING: vmlinux.o(.data+0x1a58f8): Section mismatch: reference to .init.text.19:aha1542_detect (between 'driver_template' and 'aha1542_lock')
WARNING: vmlinux.o(.data+0x1b0564): Section mismatch: reference to .init.text.19:in2000_detect (between 'driver_template' and 'setup_args')
WARNING: vmlinux.o(.data+0x1b0634): Section mismatch: reference to .init.text.19:generic_NCR5380_detect (between 'driver_template' and '__param_str_dtc_3181e')
WARNING: vmlinux.o(.data+0x1b075c): Section mismatch: reference to .init.text.19:generic_NCR5380_detect (between 'driver_template' and '__param_str_dtc_3181e')
WARNING: vmlinux.o(.data+0x1b08ac): Section mismatch: reference to .init.text.19:NCR53c406a_detect (between 'driver_template' and 'NCR_D700_driver')
WARNING: vmlinux.o(.data+0x1b0be0): Section mismatch: reference to .init.text.19:NCR_Q720_probe (between 'NCR_Q720_driver' and 'banner.22029')
WARNING: vmlinux.o(.data+0x1b0e98): Section mismatch: reference to .init.text.19:sym53c416_detect (between 'driver_template' and 'sym53c416_lock')
WARNING: vmlinux.o(.data+0x1c9de4): Section mismatch: reference to .init.text.19:pas16_detect (between 'driver_template' and 'irq')
WARNING: vmlinux.o(.data+0x1c9e7c): Section mismatch: reference to .init.text.19:seagate_st0x_detect (between 'driver_template' and 'hostno')
WARNING: vmlinux.o(.data+0x1c9f50): Section mismatch: reference to .init.text.19:t128_detect (between 'driver_template' and 'dmx3191d_pci_driver')
WARNING: vmlinux.o(.data+0x1ca1fc): Section mismatch: reference to .init.text.19:dtc_detect (between 'driver_template' and 'sym_fw2')
WARNING: vmlinux.o(.data+0x1ccd60): Section mismatch: reference to .init.text.19:wd7000_detect (between 'driver_template' and 'freescbs')
WARNING: vmlinux.o(.data+0x1ce4ec): Section mismatch: reference to .init.text.19:gdth_detect (between 'driver_template' and 'gdth_notifier')
WARNING: vmlinux.o(.data+0x1e1e20): Section mismatch: reference to .init.text.19:cfag12864bfb_probe (between 'cfag12864bfb_driver' and 'cfag12864bfb_ops')
WARNING: vmlinux.o(.data+0x1e4f34): Section mismatch: reference to .init.text.19:plat_nand_probe (between 'plat_nand_driver' and 'onenand_oob_64')
WARNING: vmlinux.o(.data+0x1e8450): Section mismatch: reference to .init.text.19:cpu_has_kvm_support (between 'vmx_arch_ops' and 'kvm_vmx_segment_fields')
WARNING: vmlinux.o(.data+0x1e8454): Section mismatch: reference to .init.text.19:vmx_disabled_by_bios (between 'vmx_arch_ops' and 'kvm_vmx_segment_fields')
WARNING: vmlinux.o(.data+0x1e8460): Section mismatch: reference to .init.text.19:hardware_setup (between 'vmx_arch_ops' and 'kvm_vmx_segment_fields')
WARNING: vmlinux.o(.data+0x1e8584): Section mismatch: reference to .init.text.19:svm_hardware_setup (between 'svm_arch_ops' and 'aoe_bdops')
WARNING: vmlinux.o(.data+0x1eb3ac): Section mismatch: reference to .init.text.19:r8a66597_probe (between 'r8a66597_driver' and 'r8a66597_hc_driver')
WARNING: vmlinux.o(.data+0x27b49c): Section mismatch: reference to .init.text.19:stk17ta8_rtc_probe (between 'stk17ta8_rtc_driver' and 'stk17ta8_nvram_attr')
WARNING: vmlinux.o(.data+0x2a913c): Section mismatch: reference to .init.text.19:pci_eisa_init (between 'pci_eisa_driver' and 'pci_eisa_pci_tbl')

...


...

 Building modules, stage 2.
  CC      arch/i386/boot/a20.o
  CC      arch/i386/boot/apm.o
  CC      arch/i386/boot/cmdline.o
  MODPOST 13 modules
WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux(.text+0xc139103b): Section mismatch: reference to .init.text:kernel_init (between 'rest_init' and 'kthreadd_setup')
WARNING: vmlinux(.text+0xc13971fb): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1397207): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1397213): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc139721f): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1391104): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and 'zone_wait_table_init')
WARNING: vmlinux(.text+0xc13911ad): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and 'vgacon_scrollback_startup')
  AS      arch/i386/boot/copy.o
  CC      arch/i386/boot/cpu.o
  CC      arch/i386/boot/cpucheck.o
  CC      arch/i386/boot/edd.o
  AS      arch/i386/boot/header.o
  CC      arch/i386/boot/main.o
  CC      arch/i386/boot/mca.o
  CC      arch/i386/boot/memory.o
  CC      arch/i386/boot/pm.o
  AS      arch/i386/boot/pmjump.o
WARNING: vmlinux(.text+0xc1397843): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1391201): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_scrollback_startup' and 'fb_find_logo')
WARNING: vmlinux(.text+0xc1391225): Section mismatch: reference to .init.data:logo_linux_mono (between 'fb_find_logo' and '__sched_text_start')
  CC      arch/i386/boot/printf.o
WARNING: vmlinux(.text+0xc139122f): Section mismatch: reference to .init.data:logo_linux_clut224 (between 'fb_find_logo' and '__sched_text_start')
WARNING: vmlinux(.text+0xc1391234): Section mismatch: reference to .init.data:logo_linux_vga16 (between 'fb_find_logo' and '__sched_text_start')
  CC      arch/i386/boot/string.o
  CC      arch/i386/boot/tty.o
WARNING: vmlinux(.text+0xc1397b60): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')

...


Regards,

Gabriel C
