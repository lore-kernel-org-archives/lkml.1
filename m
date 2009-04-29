Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZD2Jg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZD2Jg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZD2Jgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:36:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbZD2Jgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:36:39 -0400
Date: Wed, 29 Apr 2009 11:36:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stuart Bennett <stuart@freedesktop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mmiotrace: various fixes and cleaning
Message-ID: <20090429093621.GA31185@elte.hu>
References: <1240946271-7083-1-git-send-email-stuart@freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240946271-7083-1-git-send-email-stuart@freedesktop.org>
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


* Stuart Bennett <stuart@freedesktop.org> wrote:

> Hi all, this set contains one bug fix, a couple of cleanups, and a better fix
> to the mmiotrace+gdb issue
> 
> Pekka Paalanen has kindly reviewed and acked all the changes.
> 
> It has been tested on 2.6.30-rc3 using a 32 bit processor and tracing the
> proprietary Nvidia driver, and also builds cleanly on today's tip/master on
> a 64 bit system
> 
> Stuart
> 
> Stuart Bennett (4):
>       x86 mmiotrace: fix range test
>       x86 mmiotrace: code consistency/legibility improvement
>       x86 mmiotrace: refactor clearing/restore of page presence
>       x86 mmiotrace: only register for die notifier when tracer active
> 
>  arch/x86/mm/kmmio.c       |  100 ++++++++++++++++++++++++++-------------------
>  arch/x86/mm/mmio-mod.c    |    2 +
>  include/linux/mmiotrace.h |    2 +
>  3 files changed, 62 insertions(+), 42 deletions(-)

I've applied:

  33015c8: tracing: x86, mmiotrace: fix range test

to tip:tracing/urgent for v2.6.30, and have applied the other 3 
patches to tip:tracing/mmiotrace, for v2.6.31:

  0f9a623: tracing: x86, mmiotrace: only register for die notifier when tracer active
  46e91d0: tracing: x86, mmiotrace: refactor clearing/restore of page presence
  0492e1b: tracing: x86, mmiotrace: code consistency/legibility improvement

Thanks Stuart!

	Ingo
