Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbYF0QIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbYF0QIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbYF0QIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:08:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbYF0QIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:08:37 -0400
Date: Fri, 27 Jun 2008 18:08:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH 1/2] stacktrace: add saved stack traces to
	backtrace self-test
Message-ID: <20080627160821.GA30232@elte.hu>
References: <20080627160448.GB8852@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627160448.GB8852@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> I'm not really sure to whom this goes. It seems that the original code 
> came through the x86 tree, although the code itself seems to be 
> entirely generic.

given that i've written the generic stacktrace code for lockdep, i guess 
it comes to me - the only question would be into which branch ;-)

fortunately there's already a tip/core/stacktrace topic, hosting a 
change for you as well:

 Ingo Molnar (1):
       debugging: make stacktrace independent from DEBUG_KERNEL

 Johannes Berg (1):
       stacktrace: don't crash on invalid stack trace structs

 Vegard Nossum (1):
       stacktrace: print_stack_trace() cleanup

i'll queue this one up there.

	Ingo
