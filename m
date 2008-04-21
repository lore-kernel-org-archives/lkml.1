Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYDUADh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYDUADh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYDUADG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:03:06 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46055 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbYDUADE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:03:04 -0400
Date: Mon, 21 Apr 2008 03:02:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Starikovskiy <astarikovskiy@suse.de>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com,
       James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org
Subject: Voyager phys_cpu_present_map compile error
Message-ID: <20080421000238.GD26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2fe60147570231cde0d1f14711d2e34ccdf54b65
(x86: move up & smp variables to setup.c) broke Voyager:

<--  snip  -->

...
  LD      vmlinux.o
arch/x86/mach-voyager/built-in.o:(.bss+0x30): multiple definition of `phys_cpu_present_map'
arch/x86/kernel/built-in.o:(.bss+0x13c8): first defined here
ld: Warning: size of symbol `phys_cpu_present_map' changed from 32 in 
arch/x86/kernel/built-in.o to 8 in arch/x86/mach-voyager/built-in.o
make[1]: *** [vmlinux.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

