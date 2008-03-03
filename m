Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbYCCT2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbYCCT2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762818AbYCCT23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:28:29 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56829 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762801AbYCCT22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:28:28 -0500
Date: Mon, 3 Mar 2008 21:26:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: wli@holomorphy.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sparc vs. gcc 4.3
Message-ID: <20080303192651.GL26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to build a sparc kernel with a gcc 4.3 release candidate fails 
with the following error:

<--  snip  -->

...
  LD      arch/sparc/boot/image
arch/sparc/kernel/built-in.o:(__ex_table+0x394): undefined reference to `kernel_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x39c): undefined reference to `kernel_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x3a4): undefined reference to `kernel_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x3ac): undefined reference to `kernel_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x3b4): undefined reference to `kernel_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x3bc): more undefined references to `kernel_unaligned_trap_fault' follow
arch/sparc/kernel/built-in.o:(__ex_table+0x46c): undefined reference to `user_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x474): undefined reference to `user_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x47c): undefined reference to `user_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x484): undefined reference to `user_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x48c): undefined reference to `user_unaligned_trap_fault'
arch/sparc/kernel/built-in.o:(__ex_table+0x494): more undefined references to `user_unaligned_trap_fault' follow
make[2]: *** [arch/sparc/boot/image] Error 1

<--  snip  -->

Does anyone have a clue what's going wrong here?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

