Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZHXT6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZHXT6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZHXT6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:58:05 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57121 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZHXT6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SmGxGzr6hWwnWkv4ynqujhPvRKD3sw7d+ZuprS+q86REkOUARQAnpBuU/nfjcRMoe3
         58XO6LQqmmY2QLnB3W///kMixuSZ6bIkJbr533kxAPrchJ+vww7Tc5PmBXvT6bNniRLQ
         wCRB4ghMvrU8GTywzNNzLT4NcJ1Wqyewjetiw=
Date: Mon, 24 Aug 2009 21:58:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824195759.GA5050@nowhere>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <4A92EA8E.8020400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A92EA8E.8020400@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 12:31:26PM -0700, Josh Stone wrote:
> On 08/23/2009 02:14 PM, Frederic Weisbecker wrote:
> > I really don't like that.
> > See how the s390 and x86 version of the above code are completely
> > identical?
> > 
> > Please put this in kernel/ptrace.c
> 
> Yes, I see your point, and I think kernel/ptrace.c is a fine place for
> it.  Making it conditional on CONFIG_TRACEPOINTS and
> CONFIG_HAVE_FTRACE_SYSCALLS is probably best too, though I think the
> latter should now be HAVE_SYSCALL_TRACEPOINTS.


As you prefer, this new name can be indeed more verbose.

Thanks.

 
> Thanks,
> 
> Josh

