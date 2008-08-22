Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYHVPWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYHVPWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYHVPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:21:09 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51489 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbYHVPVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:21:07 -0400
Date: Fri, 22 Aug 2008 18:20:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh64 put_user() breakage
Message-ID: <20080822152040.GC26762@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 42fd3b142d8867f5b58d6fb75592cd20fd654c1b
(sh: Initial consolidation of the _32/_64 uaccess split.)
causes the following build error:

<--  snip  -->

...
  CC      arch/sh/kernel/ptrace_64.o
cc1: warnings being treated as errors
arch/sh/kernel/ptrace_64.c: In function 'arch_ptrace':
arch/sh/kernel/ptrace_64.c:162: error: passing argument 1 of '__put_user_asm_b' makes pointer from integer without a cast
arch/sh/kernel/ptrace_64.c:162: error: passing argument 2 of '__put_user_asm_b' makes integer from pointer without a cast
arch/sh/kernel/ptrace_64.c:162: error: passing argument 1 of '__put_user_asm_w' makes pointer from integer without a cast
arch/sh/kernel/ptrace_64.c:162: error: passing argument 2 of '__put_user_asm_w' makes integer from pointer without a cast
arch/sh/kernel/ptrace_64.c:162: error: passing argument 1 of '__put_user_asm_l' makes pointer from integer without a cast
arch/sh/kernel/ptrace_64.c:162: error: passing argument 2 of '__put_user_asm_l' makes integer from pointer without a cast
arch/sh/kernel/ptrace_64.c:162: error: passing argument 1 of '__put_user_asm_q' makes pointer from integer without a cast
arch/sh/kernel/ptrace_64.c:162: error: passing argument 2 of '__put_user_asm_q' makes integer from pointer without a cast
make[2]: *** [arch/sh/kernel/ptrace_64.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


