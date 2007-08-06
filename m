Return-Path: <linux-kernel-owner+w=401wt.eu-S1765595AbXHFV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765595AbXHFV2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbXHFV2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:28:04 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:59271 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbXHFV2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:28:01 -0400
X-Greylist: delayed 6890 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 17:28:00 EDT
Date: Mon, 6 Aug 2007 23:33:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070806193314.GB101@tv-sign.ru>
References: <1185992994.2636.142.camel@imap.mvista.com> <20070801201802.GA225@tv-sign.ru> <1186000468.2636.168.camel@imap.mvista.com> <20070801205053.GA263@tv-sign.ru> <1186002783.9513.228.camel@ghaskins-t60p.haskins.net> <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net> <20070802195049.GA361@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802195049.GA361@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory, we seem to more or less agree with each other, but still...

On 08/02, Oleg Nesterov wrote:
>
> On 08/01, Gregory Haskins wrote:
> >
> > On Thu, 2007-08-02 at 02:22 +0400, Oleg Nesterov wrote:
> > 
> > > No,
> > 
> > You sure are a confident one ;)
> 
> Yeah, this is a rare case when I am very sure I am right ;)
> 
> I strongly believe you guys take a _completely_ wrong approach.
> queue_work() should _not_ take the priority of the caller into
> account, this is bogus.

OK. I have to take my words back. I completely misunderstood why you
are doing this and which problems you are trying to solve, my bad.

Perhaps, I am also wrong on the "work_struct's could be re-ordered"
issue. Yes, we can break the code which is currently correct, that
was my point. But I must admit, I can't imagine the "good" code mich
may suffer. Perhaps we can just document the change in behaviour, and
"deprecate" such a code.

The only objection (and you seem to agree) is that the "regular"
queue_work() should not always take the callers's priority as the
priority of work_struct.

Oleg.

