Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYIIHET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYIIHET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYIIHEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:04:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38505 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYIIHEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:04:04 -0400
Date: Tue, 9 Sep 2008 09:03:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
Message-ID: <20080909070329.GD2086@elte.hu>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220906643.31846.21.camel@bobble.smo.corp.google.com>
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


* Frank Mayhar <fmayhar@google.com> wrote:

> Overview
> 
> This patch reworks the handling of POSIX CPU timers, including the 
> ITIMER_PROF, ITIMER_VIRT timers and rlimit handling.  It was put 
> together with the help of Roland McGrath, the owner and original 
> writer of this code.

[ i've extended the Cc: line accordingly. ]

	Ingo
