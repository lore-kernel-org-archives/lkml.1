Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYFTKFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYFTKFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYFTKFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:05:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56019 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbYFTKFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:05:23 -0400
Date: Fri, 20 Jun 2008 12:04:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bisecting tip/auto-x86-next?
Message-ID: <20080620100452.GB17692@elte.hu>
References: <485AFC9B.7090502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <485AFC9B.7090502@gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

>
> Hi,
>
> I am trying to track down a problem I reported here:
>
> http://lkml.org/lkml/2008/6/11/431
>
> None or you were cc'd on the original report because I had no idea of  
> the source of the issue.  However, I have now narrowed down the problem  
> to the auto-x86-next tree.  Thus I did something like:
>
> $ git bisect start
> $ git bisect good linus/master
> $ git bisect bad tip/auto-x86-next
>
> which resulted in only about 170 or so revisions to test (sounds better  
> than the 3000 or so that -next wanted me to bisect through).  However,  
> when I tried to compile the bisect-chosen commit, I get:
>
> ------------------
>
> In file included from include/asm/thread_info.h:5,
>                  from include/linux/thread_info.h:47,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:49,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:8,
>                  from include/linux/stat.h:60,
>                  from include/linux/module.h:10,
>                  from crypto/sha1_generic.c:20:
> include/asm/thread_info_64.h: In function ‘set_restore_sigmask’:
> include/asm/thread_info_64.h:189: warning: passing argument 2 of  
> ‘set_bit’ from incompatible pointer type

hm, could you send me the config that triggered this?

	Ingo
