Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033Ab0AYAQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0AYAQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 19:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890Ab0AYAQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 19:16:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0AYAQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 19:16:16 -0500
Date: Sun, 24 Jan 2010 22:16:05 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] tools/perf/perf.c: Clean up trivial style issues.
Message-ID: <20100125001605.GD2689@ghostprotocols.net>
References: <6da2dcba6dce85a338cfe948591db4da4957257b.1264374841.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6da2dcba6dce85a338cfe948591db4da4957257b.1264374841.git.tfransosi@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jan 24, 2010 at 06:21:46PM -0500, Thiago Farina escreveu:
> Checked with:
> ./../scripts/checkpatch.pl --terse --file perf.c
> 
> perf.c:51: ERROR: open brace '{' following function declarations go on the next line
> perf.c:73: ERROR: "foo*** bar" should be "foo ***bar"
> perf.c:112: ERROR: space prohibited before that close parenthesis ')'
> perf.c:127: ERROR: space prohibited before that close parenthesis ')'
> perf.c:171: ERROR: "foo** bar" should be "foo **bar"
> perf.c:213: ERROR: "(foo*)" should be "(foo *)"
> perf.c:216: ERROR: "(foo*)" should be "(foo *)"
> perf.c:217: ERROR: space required before that '*' (ctx:OxV)
> perf.c:452: ERROR: do not initialise statics to 0 or NULL
> perf.c:453: ERROR: do not initialise statics to 0 or NULL

I'm ok with this, all comes from git lack of checkpatchin', from where
this code was stolen^Wlifted, I guess :-)

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
