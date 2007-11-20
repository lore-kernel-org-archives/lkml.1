Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbXKTOWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbXKTOWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXKTOWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:22:35 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:50880 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753057AbXKTOWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:22:34 -0500
Message-ID: <4742EDA1.3080308@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2007 19:52:25 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Failure mach_apic.h
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
In-Reply-To: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, on one of the machine 

  CC      arch/x86/mach-generic/summit.o
In file included from arch/x86/mach-generic/summit.c:16:
include/asm/mach-summit/mach_apic.h: In function ‘target_cpus’:
include/asm/mach-summit/mach_apic.h:23: error: ‘per_cpu__cpu_mask’ undeclared (first use in this function)
include/asm/mach-summit/mach_apic.h:23: error: (Each undeclared identifier is reported only once
include/asm/mach-summit/mach_apic.h:23: error: for each function it appears in.)
include/asm/mach-summit/mach_apic.h:23: warning: type defaults to ‘int’ in declaration of ‘type name’
include/asm/mach-summit/mach_apic.h:23: error: invalid type argument of ‘unary *’
make[1]: *** [arch/x86/mach-generic/summit.o] Error 1
make: *** [arch/x86/mach-generic] Error 2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
