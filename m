Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbZJOJWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbZJOJWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbZJOJWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:22:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbZJOJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:22:50 -0400
Subject: Re: [PATCH 12/13] [PATCH 12/13] perf tools: handle - and + in
 parsing trace print format
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <1255590330.8392.446.camel@twins>
References: <20091014194330.980165492@goodmis.org>
	 <20091014194400.330843045@goodmis.org>  <20091015064240.GC11645@elte.hu>
	 <1255590330.8392.446.camel@twins>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 15 Oct 2009 05:20:51 -0400
Message-Id: <1255598451.31684.492.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 09:05 +0200, Peter Zijlstra wrote:
> On Thu, 2009-10-15 at 08:42 +0200, Ingo Molnar wrote:
> 
> > > -CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
> > > +CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
> > 
> > hm, why does this patch change the Makefile?
> > 
> > i've skipped this hunk, it does not appear to be connected to the 
> > commit.
> 
> Probably because he wanted to debug things and O6 generates crappy gdb
> experience.. and then it slipped into the diff

Yeah, that's exactly what happened. Damn, I thought I put the -O6 back.
This patch, I originally just did the '-', and thought. Hmm, it is
trivial to do the '+'. So I added it and did a "git commit -a --amend",
forgetting that I modified the Makefile.

This hunk can be ignored.

Thanks!

-- Steve


