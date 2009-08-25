Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZHYIBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZHYIBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZHYIBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:01:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34640 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZHYIBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:01:35 -0400
Message-Id: <4A93B67D02000078000118B2@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 25 Aug 2009 09:01:33 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <tglx@linutronix.de>, <mingo@redhat.com>,
       <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86: Fix build with older binutils and
	 consolidate linker script
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com>
 <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org>
 <20090825075029.GA857@elte.hu>
In-Reply-To: <20090825075029.GA857@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was that using a UP config perhaps?

Jan

>>> Ingo Molnar <mingo@elte.hu> 25.08.09 09:50 >>>

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

