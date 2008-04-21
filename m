Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbYDUADM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbYDUADM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYDUAC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:02:59 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:32777 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYDUAC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:02:59 -0400
Date: Mon, 21 Apr 2008 03:02:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
       James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org
Subject: Voyager setup_trampoline() compile error
Message-ID: <20080421000232.GC26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 77ad386e596c6b0930cc2e09e3cce485e3ee7f72
(x86: standalone trampoline code) broke Voyager:

<--  snip  -->

...
  LD      vmlinux.o
arch/x86/mach-voyager/built-in.o:(.bss+0x50): multiple definition of `trampoline_base'
arch/x86/kernel/built-in.o:(.data+0x820): first defined here
arch/x86/mach-voyager/built-in.o: In function `setup_trampoline':
(.init.text+0x30e): multiple definition of `setup_trampoline'
arch/x86/kernel/built-in.o:(.text+0x57c8): first defined here
make[1]: *** [vmlinux.o] Error 1


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

