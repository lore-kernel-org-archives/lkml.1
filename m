Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbYFMLTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbYFMLTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYFMLTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:19:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbYFMLTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:19:13 -0400
Date: Fri, 13 Jun 2008 13:18:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stacktrace: print_stack_trace() cleanup
Message-ID: <20080613111855.GD9867@elte.hu>
References: <20080613090014.GC3139@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613090014.GC3139@damson.getinternet.no>
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

> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 13 Jun 2008 10:05:26 +0200
> Subject: [PATCH] stacktrace: print_stack_trace() cleanup
> 
> This admittedly doesn't have too many benefits, these are the two I 
> can think of: shorter code and better atomicity with regards to 
> printk().
> 
> (It's been tested with the backtrace self-test code on i386 and 
> x86_64.)

applied to tip/core/stacktrace - thanks Vegard. (I have hand-merged it 
as there were a few stacktrace changes in the stacktrace tree already, 
queued up for v2.6.27.)

	Ingo
