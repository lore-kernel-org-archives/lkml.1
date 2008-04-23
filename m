Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYDWQHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYDWQHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYDWQGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:06:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59807 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbYDWQGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:06:48 -0400
Date: Wed, 23 Apr 2008 19:06:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Roland McGrath <roland@redhat.com>, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: mips ptrace compat build error
Message-ID: <20080423160607.GS28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e16b27816462de700f9508d86954410c41105dc2
(ptrace: compat_ptrace_request siginfo) causes
the following build error with CONFIG_COMPAT=y
on mips:

<--  snip   -->

...
  LD      .tmp_vmlinux1
kernel/built-in.o: In function `$L181':
ptrace.c:(.text+0x1d380): undefined reference to `copy_siginfo_from_user32'
ptrace.c:(.text+0x1d380): relocation truncated to fit: R_MIPS_26 against `copy_siginfo_from_user32'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

