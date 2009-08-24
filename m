Return-Path: <linux-kernel-owner+w=401wt.eu-S1751105AbZHXL3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbZHXL3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZHXL3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:29:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47924 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZHXL3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:29:09 -0400
Date: Mon, 24 Aug 2009 20:29:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Josh Stone <jistone@redhat.com>,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 1/4] tracing: Rename TIF_SYSCALL_FTRACE->_TRACEPOINT
Message-ID: <20090824112910.GA18752@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
	Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Jiaying Zhang <jiayingz@google.com>,
	Martin Bligh <mbligh@google.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <20090823211625.GH6256@nowhere> <20090824084245.GF2424@elte.hu> <20090824111148.GA6130@nowhere> <20090824112426.GA10215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824112426.GA10215@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 01:24:26PM +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Mon, Aug 24, 2009 at 10:42:45AM +0200, Ingo Molnar wrote:
> > > 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > On Fri, Aug 21, 2009 at 09:58:42PM -0700, Josh Stone wrote:
> > > >
> > > > > This thread flag is no longer specific to just ftrace, so 
> > > > > TIF_SYSCALL_TRACEPOINT may be a more apt name.
> > > > 
> > > > Adding Paul Mundt <lethal@linux-sh.org> in Cc, the sh tree also 
> > > > has the syscalls tracing support (in a seperate branch).
> > > 
> > > Btw., is there an URI for that separate branch?
> > > 
> > > 	Ingo
> > 
> > I guess it's:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git \
> > 	sh/ftrace
> 
> ok, i checked - this is not a pure topical tree, it's intermingled 
> with other SH changes, so it cannot be pulled into the tracing tree.
> 
> Obviously only such trees can be pulled into the tracing tree that 
> limit their role to tracing and are non-rebasing.
> 
Yes, post-2.6.32 merge window I'll keep the sh/ftrace branch isolated
from the rest of the sh changes, at which point it should be possible to
pull in to -tip directly. I generally do not rebase topic branches.
