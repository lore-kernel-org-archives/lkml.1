Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYLCHf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYLCHf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYLCHfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:35:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbYLCHfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:35:17 -0500
Date: Wed, 3 Dec 2008 08:35:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: v2.6.28-rc7: Fail compile arch/x86/kernel/cpu/common.c
Message-ID: <20081203073504.GB17580@elte.hu>
References: <20081203070115.GA32403@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081203070115.GA32403@ubuntu>
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


* Jianjun Kong <jianjun@zeuux.org> wrote:

> arch/x86/kernel/cpu/common.c: In function ‘early_identify_cpu’:
> arch/x86/kernel/cpu/common.c:555: error: ‘boot_cpu_id’ undeclared (first
> use in this function)
> arch/x86/kernel/cpu/common.c:555: error: (Each undeclared identifier is
> reported only once
> arch/x86/kernel/cpu/common.c:555: error: for each function it appears
> in.)
> arch/x86/kernel/cpu/common.c: In function ‘cpu_init’:
> arch/x86/kernel/cpu/common.c:1142: error: ‘boot_cpu_id’ undeclared
> (first use in this function)
> make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
> make[1]: *** [arch/x86/kernel/cpu] Error 2
> make: *** [arch/x86/kernel] Error 2

i cannot reproduce this build error neither with v2.6.28-rc7 nor 
with latest -git (commit f6f7b52), using your config.

could you send me your arch/x86/include/asm/smp.h file? Could 
you also double-check that you have the kernel source tree 
checked out properly? If you track it as a remote as per:

  http://people.redhat.com/mingo/tip.git/README

then doing "git checkout linus/master" should succeed without 
any errors beyond the warning that it is a remote branch:

 ~/tip> git checkout linus/master
 Note: moving to "linus/master" which isn't a local branch
 If you want to create a new branch from this checkout, you may do so
 (now or later) by using -b with the checkout command again. 
 Example:
   git checkout -b <new_branch_name>
 HEAD is now at f6f7b52... Merge git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog
 ~/tip>

	Ingo
