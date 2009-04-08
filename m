Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbZDHI0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbZDHI0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZDHIZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:25:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZDHIZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:25:45 -0400
Date: Wed, 8 Apr 2009 10:25:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc1] Append a comma to INIT_FTRACE_GRAPH.
Message-ID: <20090408082531.GA5648@elte.hu>
References: <200904080505.n3855hcn017109@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904080505.n3855hcn017109@www262.sakura.ne.jp>
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


* Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Due to lack of a comma, build fails if elements are appended to
> INIT_TASK() macro.
> 
> arch/x86/kernel/init_task.c:33: error: request for member `XXXXXXXXXX' in something not a structure or union
> arch/x86/kernel/init_task.c:33: error: initializer element is not constant
> arch/x86/kernel/init_task.c:33: error: (near initialization for `init_task.ret_stack')
> make[1]: *** [arch/x86/kernel/init_task.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  include/linux/ftrace.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to tip:tracing/urgent, thanks. (It is not a problem right 
now because this is the last in the line, but it will become a 
problem the moment something is appended.)

	Ingo
