Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbXDFTRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbXDFTRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXDFTRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:17:05 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:52829 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXDFTRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:17:02 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 6 Apr 2007 12:16:59 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
 <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
 <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
 <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com>
 <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru>
 <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
 <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Eric W. Biederman wrote:

> Davide Libenzi <davidel@xmailserver.org> writes:
> 
> > On Fri, 6 Apr 2007, Oleg Nesterov wrote:
> >
> >> Sure. It would be nice to move ->children into signal_struct at first.
> >> Except this change breaks (in fact fixes) ->pdeath_signal behaviour.
> >
> > Ohhh, the "signal" struct! Funny name for something that nowadays has 
> > probably no more than a 5% affinity with signal-related tasks :/
> 
> Hmm.  I wonder if we should just rename it the struct thread_group,
> or struct task_group.  Those seem slightly more accurate names.

Almost *anything* is better than "signal_struct" ;)
A task_group could be fine, so something on the line of task_shared_ctx.



- Davide


