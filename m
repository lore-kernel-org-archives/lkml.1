Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbXB1X0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbXB1X0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXB1X0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:26:03 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:43020 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbXB1X0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BvQFSbKjq77DZzqqDtS2dHrwCbGc6bKMITaip1eli3/H78WRNn1h+PIlci++sqdArNpC2yX+LKaWoTqX3FWmg8nZgkTaiOqw38gVlbL770AjNSXW73f255zdrohS4cvBZY+8OxrdSlxnmFjBtEzm4vs4WByF2F+j1Esblu2OjA8=
Message-ID: <d45a3acc0702281525j655374a7x9551169995af44@mail.gmail.com>
Date: Thu, 1 Mar 2007 10:25:50 +1100
From: "andrew hendry" <andrew.hendry@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc1 build errors with X86_VOYAGER=y
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.21-rc2-git2
from some make randconfig

# CONFIG_SMP is not set
CONFIG_X86_VOYAGER=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

LD      .tmp_vmlinux1
arch/i386/kernel/built-in.o: In function `vic_sys_interrupt':
 (.text+0x3141): undefined reference to `smp_vic_sys_interrupt'
arch/i386/kernel/built-in.o: In function `vic_cmn_interrupt':
(.text+0x3171): undefined reference to `smp_vic_cmn_interrupt'
arch/i386/kernel/built-in.o: In function `vic_cpi_interrupt':
(.text+0x31a1): undefined reference to `smp_vic_cpi_interrupt'
arch/i386/kernel/built-in.o: In function `qic_timer_interrupt':
(.text+0x31d1): undefined reference to `smp_qic_timer_interrupt'
arch/i386/kernel/built-in.o: In function `qic_invalidate_interrupt':
  (.text+0x3201): undefined reference to `smp_qic_invalidate_interrupt'
arch/i386/kernel/built-in.o: In function `qic_reschedule_interrupt':
(.text+0x3231): undefined reference to `smp_qic_reschedule_interrupt'
arch/i386/kernel/built-in.o: In function `qic_enable_irq_interrupt':
(.text+0x3261): undefined reference to `smp_qic_enable_irq_interrupt'
arch/i386/kernel/built-in.o: In function `qic_call_function_interrupt':
(.text+0x3291): undefined reference to `smp_qic_call_function_interrup
t'
arch/i386/kernel/built-in.o: In function `setup_bootmem_allocator':
(.init.text+0x606): undefined reference to `find_smp_config'
arch/i386/mach-voyager/built-in.o: In function `voyager_power_off':
(.text+0x1d4): undefined reference to `voyager_cat_power_off'
arch/i386/mach-voyager/built-in.o: In function `thread':
voyager_thread.c:(.text+0x41f): undefined reference to `voyager_status'
voyager_thread.c:(.text+0x476): undefined reference to `voyager_status'
voyager_thread.c:(.text+0x489): undefined reference to `voyager_cat_psi'
voyager_thread.c:(.text+0x4c3): undefined reference to `voyager_status'
voyager_thread.c:(.text+0x4d6): undefined reference to `voyager_status'

CONFIG_SMP=y
CONFIG_X86_VOYAGER=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

arch/i386/kernel/built-in.o: In function `msr_read':
msr.c:(.text+0xbd15): undefined reference to `smp_call_function_single'
arch/i386/kernel/built-in.o: In function `msr_write':
msr.c:(.text+0xbe41): undefined reference to `smp_call_function_single'
 arch/i386/kernel/built-in.o: In function `cpuid_read':
cpuid.c:(.text+0xc069): undefined reference to `smp_call_function_single'


CONFIG_SMP=y
CONFIG_X86_VOYAGER=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y

arch/i386/kernel/built-in.o: In function `cpuid_read':
cpuid.c:(.text+0xbce9): undefined reference to `smp_call_function_single'

CONFIG_SMP=y
CONFIG_X86_VOYAGER=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

Builds ok
