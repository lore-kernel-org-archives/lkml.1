Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbXIVFDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbXIVFDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 01:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXIVFDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 01:03:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44942 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXIVFDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 01:03:34 -0400
Date: Sat, 22 Sep 2007 10:36:30 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andi Kleen <ak@suse.de>
cc: patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [34/50] i386: Fix argument signedness warnings
In-Reply-To: <20070921223234.0A71513DCD@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0709221029170.19812@enigma.security.iitk.ac.in>
References: <200709221231.836138000@suse.de>
 <20070921223234.0A71513DCD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Sat, 22 Sep 2007, Andi Kleen wrote:
> 
> From: Satyam Sharma <satyam@infradead.org>
> 
> 
> These build warnings:
> 
> In file included from include/asm/thread_info.h:16,
> from include/linux/thread_info.h:21,
> from include/linux/preempt.h:9,
> from include/linux/spinlock.h:49,
> from include/linux/vmalloc.h:4,
> from arch/i386/boot/compressed/misc.c:14:
> include/asm/processor.h: In function ‘cpuid_count’:
                                       ^^^^^^^^^^           ^^^^^^^^^^
> include/asm/processor.h:615: warning: pointer targets in passing
> argument 1 of ‘native_cpuid’ differ in signedness

> include/asm/processor.h:615: warning: pointer targets in passing
> argument 2 of ‘native_cpuid’ differ in signedness

> include/asm/processor.h:615: warning: pointer targets in passing
> argument 3 of ‘native_cpuid’ differ in signedness

> include/asm/processor.h:615: warning: pointer targets in passing
> argument 4 of ‘native_cpuid’ differ in signedness
                ^^^^^^^^^^            ^^^^^^^^^^

Yikes. My bad, I had faulty (default) alpine settings (and a sad
combination of LANG=en_US.UTF-8) when I made and sent out that patch.
Please ensure that this finally gets committed in a somewhat saner and
more readable state to the tree.

Thanks,

Satyam
