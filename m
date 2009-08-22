Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbZHVKdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbZHVKdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 06:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZHVKdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 06:33:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbZHVKdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 06:33:05 -0400
Date: Sat, 22 Aug 2009 12:32:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090822103252.GA32369@elte.hu>
References: <20090814134811.013873340@de.ibm.com> <tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org>
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


* tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> Commit-ID:  d4f587c67fc39e0030ddd718675e252e208da4d7
> Gitweb:     http://git.kernel.org/tip/d4f587c67fc39e0030ddd718675e252e208da4d7
> Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
> AuthorDate: Fri, 14 Aug 2009 15:47:31 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Sat, 15 Aug 2009 10:55:46 +0200
> 
> timekeeping: Increase granularity of read_persistent_clock()

FYI, -tip arch-testing found that this commit broke the PowerPC 
build:

/home/mingo/tip/arch/powerpc/kernel/time.c: In function 'read_persistent_clock':
/home/mingo/tip/arch/powerpc/kernel/time.c:788: error: 'return' with a value, in function returning void
/home/mingo/tip/arch/powerpc/kernel/time.c:791: error: 'return' with a value, in function returning void
make[2]: *** [arch/powerpc/kernel/time.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/powerpc/kernel] Error 2

	Ingo
