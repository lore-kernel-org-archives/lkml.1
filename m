Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZJOHHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZJOHHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933325AbZJOHHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:07:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:35434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbZJOHHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:07:03 -0400
Subject: Re: [PATCH 12/13] [PATCH 12/13] perf tools: handle - and + in
 parsing trace print format
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20091015064240.GC11645@elte.hu>
References: <20091014194330.980165492@goodmis.org>
	 <20091014194400.330843045@goodmis.org>  <20091015064240.GC11645@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Oct 2009 09:05:30 +0200
Message-Id: <1255590330.8392.446.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 08:42 +0200, Ingo Molnar wrote:

> > -CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
> > +CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
> 
> hm, why does this patch change the Makefile?
> 
> i've skipped this hunk, it does not appear to be connected to the 
> commit.

Probably because he wanted to debug things and O6 generates crappy gdb
experience.. and then it slipped into the diff
