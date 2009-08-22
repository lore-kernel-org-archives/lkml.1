Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbZHVPeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbZHVPeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 11:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932679AbZHVPeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 11:34:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbZHVPeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 11:34:01 -0400
Date: Sat, 22 Aug 2009 17:33:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090822153346.GA3313@elte.hu>
References: <20090814134811.013873340@de.ibm.com> <tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org> <20090822103252.GA32369@elte.hu> <20090822171540.1220f50d@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090822171540.1220f50d@skybase>
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> > FYI, -tip arch-testing found that this commit broke the PowerPC 
> > build:
> > 
> > /home/mingo/tip/arch/powerpc/kernel/time.c: In function 'read_persistent_clock':
> > /home/mingo/tip/arch/powerpc/kernel/time.c:788: error: 'return' with a value, in function returning void
> > /home/mingo/tip/arch/powerpc/kernel/time.c:791: error: 'return' with a value, in function returning void
> > make[2]: *** [arch/powerpc/kernel/time.o] Error 1
> > make[2]: *** Waiting for unfinished jobs....
> > make[1]: *** [arch/powerpc/kernel] Error 2
> 
> I overlooked a case in the powerpc version of read_persistent_lock.
> New patch:

the patches are already committed and this patch doesnt apply - mind 
sending a delta fix against tip:master:

 http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
