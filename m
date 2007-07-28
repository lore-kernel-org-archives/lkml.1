Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbXG1FQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbXG1FQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 01:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXG1FQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 01:16:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:20434 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbXG1FQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 01:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=T+rJVWRA3oaxn5BPepKRhosTj1JIYoEgxUWfrjlUezaP6T2AB2OTuJ9AiHAyIzCJRZnVMVt+1EvnMr0X08+oEIIHs5X/dOT4y5PuOGVsn1wmLhDOL6CvqnEQyslAAncMYepGxg/T8dvivf7CjHS5yB7/AWcC9xnBS/2XR0Ec+Oc=
Message-ID: <a44ae5cd0707272216o60185470k30a785ebbffe57f5@mail.gmail.com>
Date: Fri, 27 Jul 2007 22:16:35 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc1-mm1 + hotfixes -- Section mismatches
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x183): Section mismatch: reference to
.init.text.1:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux.o(.data+0x53c0): Section mismatch: reference to
.init.text.4:native_smp_prepare_boot_cpu (between 'smp_ops' and
'call_lock')
WARNING: vmlinux.o(.data+0x53c4): Section mismatch: reference to
.init.text.4:native_smp_prepare_cpus (between 'smp_ops' and
'call_lock')
WARNING: vmlinux.o(.data+0x53cc): Section mismatch: reference to
.init.text.4:native_smp_cpus_done (between 'smp_ops' and 'call_lock')
WARNING: vmlinux.o(.data+0x6598): Section mismatch: reference to
.init.text.6:machine_specific_memory_setup (between 'paravirt_ops' and
'reserve_ioports')
WARNING: vmlinux.o(.data+0x65a0): Section mismatch: reference to
.init.text.4:native_init_IRQ (between 'paravirt_ops' and
'reserve_ioports')
WARNING: vmlinux.o(.data+0x65a4): Section mismatch: reference to
.init.text.4:hpet_time_init (between 'paravirt_ops' and
'reserve_ioports')
WARNING: vmlinux.o(.data+0x65a8): Section mismatch: reference to
.init.text.5:native_pagetable_setup_start (between 'paravirt_ops' and
'reserve_ioports')
WARNING: vmlinux.o(.data+0x65ac): Section mismatch: reference to
.init.text.5:native_pagetable_setup_done (between 'paravirt_ops' and
'reserve_ioports')
WARNING: vmlinux.o(.data+0x65b0): Section mismatch: reference to
.init.text.4:default_banner (between 'paravirt_ops' and
'reserve_ioports')
WARNING: vmlinux.o(.data+0x6674): Section mismatch: reference to
.init.text.4:setup_boot_APIC_clock (between 'paravirt_ops' and
'reserve_ioports')
WARNING: vmlinux.o(.data+0x17840): Section mismatch: reference to
.init.text.19:vesafb_probe (between 'vesafb_driver' and 'vesafb_ops')
WARNING: vmlinux.o(.data+0x1ef00): Section mismatch: reference to
.init.text.19:hvc_console_setup (between 'hvc_con_driver' and
'vtermnos')
WARNING: vmlinux.o(.data+0x20780): Section mismatch: reference to
.init.text.19:serial8250_console_setup (between 'serial8250_console'
and 'serial8250_reg')
WARNING: vmlinux.o(.data+0x20784): Section mismatch: reference to
.init.text.19:serial8250_console_early_setup (between
'serial8250_console' and 'serial8250_reg')
WARNING: vmlinux.o(.data+0x259cc): Section mismatch: reference to
.init.text.19:smsc_ircc_pnp_probe (between 'smsc_ircc_pnp_driver' and
'__param_str_ircc_transceiver')
WARNING: vmlinux.o(.data+0x2e5f0): Section mismatch: reference to
.init.text.19:pci_eisa_init (between 'pci_eisa_driver' and
'pci_eisa_pci_tbl')
