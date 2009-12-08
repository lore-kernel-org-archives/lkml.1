Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZLHFi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZLHFi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 00:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZLHFi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 00:38:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbZLHFiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 00:38:55 -0500
Date: Tue, 8 Dec 2009 06:38:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       Timo Sirainen <tss@iki.fi>, WANG Cong <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
Message-ID: <20091208053851.GA12383@elte.hu>
References: <20091208121145.B58D.A69D9226@jp.fujitsu.com>
 <20091208044605.GA32669@elte.hu>
 <20091208135010.B5A8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208135010.B5A8.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > The feature looks useful, but the choice of a prctl as an API is strange 
> > - it limits us to the current task only - while the ability to set 
> > arguments for another task looks a more generic (and potentially more 
> > useful) solution.
> 
> No. It's impossible.
> /proc/{pid}/cmdline read user process's memory. iow, this prctl() don't
> receive string, it receive virtual address itself. [...]

it's not 'impossible' at all, you yourself mention ptrace:

> [...] I don't want any task allow to change another task's memory 
> except ptrace.

And i did not mean to allow 'any' task to be allowed to do this - 
security checks apply, obviously.

	Ingo
