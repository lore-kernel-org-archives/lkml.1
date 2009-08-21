Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbZHUVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbZHUVEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbZHUVEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:04:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbZHUVEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:04:41 -0400
Date: Fri, 21 Aug 2009 23:04:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] tracing/syscalls: fix printk formats
Message-ID: <20090821210430.GA1039@elte.hu>
References: <20090821164140.71968b47.sfr@canb.auug.org.au> <20090821140020.c4140ca9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821140020.c4140ca9.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings:
> 
> kernel/trace/trace_syscalls.c:113: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
> kernel/trace/trace_syscalls.c:123: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'

thanks, this (and other) bugs were already fixed by Li Zefan via:

  4539f07: tracing/syscalls: Fix the output of syscalls with no arguments

	Ingo
