Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYGYKaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYGYKaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYGYKaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:30:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43399 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYGYKa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:30:29 -0400
Date: Fri, 25 Jul 2008 12:30:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] flag parameters: fix compile error of sys_epoll_create1
Message-ID: <20080725103012.GA11796@elte.hu>
References: <48898461.4070603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48898461.4070603@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wang Chen <wangchen@cn.fujitsu.com> wrote:

>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> arch/x86/kernel/built-in.o: In function `sys_call_table':
> (.rodata+0x8a4): undefined reference to `sys_epoll_create1'
> make: *** [vmlinux] Error 1

just ran into this too - 64-bit allnoconfig triggers it.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
