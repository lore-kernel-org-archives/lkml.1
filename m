Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab0CNOrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 10:47:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab0CNOrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 10:47:36 -0400
Date: Sun, 14 Mar 2010 15:47:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perf hist: Don't fprintf the callgraph
 unconditionally
Message-ID: <20100314144723.GA6705@elte.hu>
References: <1268408808-13595-1-git-send-email-acme@infradead.org>
 <1268408808-13595-2-git-send-email-acme@infradead.org>
 <20100314094732.GC5158@nowhere>
 <20100314142152.GG6965@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100314142152.GG6965@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Sun, Mar 14, 2010 at 10:47:34AM +0100, Frederic Weisbecker escreveu:
> > Hmm, so for now the callchain won't work anymore until
> > it gets properly reimplemented right?
> 
> It doesn't work in the newt interface only, it remais working if you do:
> 
> perf report | less
> perf report > output.txt
> rpm -e newt-devel ; make -C tools/perf install
> 
> :-)

We'll also need a .perfconfig variable for people who prefer flat ascii.

	Ingo
