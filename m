Return-Path: <linux-kernel-owner+w=401wt.eu-S1422914AbXBASYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422914AbXBASYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422915AbXBASYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:24:11 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:55600 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422914AbXBASYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:24:10 -0500
Message-ID: <45C23046.8000303@fr.ibm.com>
Date: Thu, 01 Feb 2007 19:24:06 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
       Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>,
       keith mannthey <kmannth@us.ibm.com>
Subject: Re: 2.6.20-rc6-mm3
References: <20070129204528.eb8d695e.akpm@osdl.org>
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

changes in git-acpi.patch in 2.6.20-rc6-mm3 (and maybe before) broke the Summit 
sub-arch (IBM x440) compile :( 

thanks, 
 
C. 

  CC      arch/i386/kernel/cpu/intel.o
  CC      arch/i386/kernel/early_printk.o
arch/i386/kernel/srat.c: In function 'parse_cpu_affinity_structure':
arch/i386/kernel/srat.c:68: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:72: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:72: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:74: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:74: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:77: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:77: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c: In function 'parse_memory_affinity_structure':
arch/i386/kernel/srat.c:93: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:97: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:97: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:100: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:101: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:102: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:103: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:108: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:134: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:135: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:136: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c: In function 'acpi20_parse_srat':
arch/i386/kernel/srat.c:188: error: 'ACPI_SRAT_PROCESSOR_AFFINITY' undeclared (first use in this function)
arch/i386/kernel/srat.c:188: error: (Each undeclared identifier is reported only once
arch/i386/kernel/srat.c:188: error: for each function it appears in.)
arch/i386/kernel/srat.c:191: error: 'ACPI_SRAT_MEMORY_AFFINITY' undeclared (first use in this function)
arch/i386/kernel/srat.c: In function 'get_memcfg_from_srat':
arch/i386/kernel/srat.c:275: error: 'ACPI_PHYSICAL_ADDRESSING' undeclared (first use in this function)
arch/i386/kernel/srat.c:275: error: too many arguments to function 'acpi_find_root_pointer'
arch/i386/kernel/srat.c:282: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:282: error: 'ACPI_PHYSICAL_POINTER' undeclared (first use in this function)
arch/i386/kernel/srat.c:285: error: dereferencing pointer to incomplete type
arch/i386/kernel/srat.c:298: error: 'RSDP_SIG' undeclared (first use in this function)
arch/i386/kernel/srat.c:304: error: 'struct acpi_table_rsdp' has no member named 'rsdt_address'
arch/i386/kernel/srat.c:315: error: 'RSDT_SIG' undeclared (first use in this function)
arch/i386/kernel/srat.c:344: error: 'struct acpi_table_rsdt' has no member named 'entry'
arch/i386/kernel/srat.c:348: error: 'struct acpi_table_rsdt' has no member named 'entry'
  SYSCALL arch/i386/kernel/vsyscall-syms.o
make[1]: *** [arch/i386/kernel/srat.o] Error 1
make[1]: *** Waiting for unfinished jobs....
