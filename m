Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbXKTVTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbXKTVTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXKTVTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:19:10 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40427 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbXKTVTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:19:08 -0500
Message-ID: <47434F2E.6080007@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2007 02:48:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Failure  - macro
 CONFIG_THREAD_ORDER not defined
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
In-Reply-To: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, with randconfig

  CC      arch/x86/kernel/asm-offsets.s
In file included from include/asm/thread_info.h:4,
                 from include/linux/thread_info.h:21,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/asm/thread_info_64.h: In function ‘current_thread_info’:
include/asm/thread_info_64.h:63: error: ‘CONFIG_THREAD_ORDER’ undeclared (first use in this function)
include/asm/thread_info_64.h:63: error: (Each undeclared identifier is reported only once
include/asm/thread_info_64.h:63: error: for each function it appears in.)
include/asm/thread_info_64.h: In function ‘stack_thread_info’:
include/asm/thread_info_64.h:71: error: ‘CONFIG_THREAD_ORDER’ undeclared (first use in this function)
In file included from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/sched.h: At top level:
include/linux/sched.h:1527: error: ‘CONFIG_THREAD_ORDER’ undeclared here (not in a function)
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

The patch git-x86.patch introduces CONFIG_THREAD_ORDER undefined macro, instead of THREAD_ORDER.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
