Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZHYHuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZHYHuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZHYHuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:50:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52247 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbZHYHui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:50:38 -0400
Date: Tue, 25 Aug 2009 09:50:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix build with older binutils and
	consolidate linker script
Message-ID: <20090825075029.GA857@elte.hu>
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com> <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Jan Beulich <JBeulich@novell.com> wrote:

> Commit-ID:  ddc98b38b6320d5de2e3167673a06ec1a48e9d0e
> Gitweb:     http://git.kernel.org/tip/ddc98b38b6320d5de2e3167673a06ec1a48e9d0e
> Author:     Jan Beulich <JBeulich@novell.com>
> AuthorDate: Tue, 18 Aug 2009 16:51:27 +0100
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Mon, 24 Aug 2009 15:51:35 -0700
> 
> x86: Fix build with older binutils and consolidate linker script

this breaks the build with newer binutils:

  LD      .tmp_vmlinux1
ld: .tmp_vmlinux1: section `.init.text' can't be allocated in segment 2
LOAD: .vsyscall_0 .vsyscall_fn .vsyscall_gtod_data .vsyscall_1 
.vsyscall_2 .vgetcpu_mode .jiffies .init.text .init.data .init.setup 
.initcall.init .con_initcall.init .x86_cpu_dev.init 
.security_initcall.init .parainstructions .altinstructions 
.altinstr_replacement .exit.text .bss .brk
ld: final link failed: Bad value
make: *** [.tmp_vmlinux1] Error 1

	Ingo
