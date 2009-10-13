Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbZJMKBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbZJMKBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759044AbZJMKBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:01:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444AbZJMKBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:01:49 -0400
Date: Tue, 13 Oct 2009 12:01:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vincent Legoll <vincent.legoll@gmail.com>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] [PERF] do not manually count string lengths
Message-ID: <20091013100101.GA26846@elte.hu>
References: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com>
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


* Vincent Legoll <vincent.legoll@gmail.com> wrote:

> Hello,
> 
> here is a small patch to the perf tool to use strlen & macros
> instead of manually counting string lengths.
> 
> I didn't find mention of any maintainer for the tool...

It's maintained by:

 PERFORMANCE EVENTS SUBSYSTEM
 M:      Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:      Paul Mackerras <paulus@samba.org>
 M:      Ingo Molnar <mingo@elte.hu>
 S:      Supported

We should add 'F:' file patterns to that entry i guess ...

Something like:

F:	kernel/perf_event.c
F:	include/linux/perf_event.h
F:	arch/*/*/kernel/perf_event.c
F:	arch/*/include/asm/perf_event.h
F:	tools/perf/

Would do the trick. Mind sending a patch for that too?

> Please advise if I should submit this in another way

Submitting it to lkml was fine enough - please Cc: it to us in the 
future to make sure we dont miss it.

Applied, thanks for the patch!

	Ingo
