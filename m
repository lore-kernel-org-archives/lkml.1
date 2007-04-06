Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXDFV3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXDFV3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXDFV3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:29:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:52846 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbXDFV3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:29:31 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 6 Apr 2007 14:29:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <20070406191945.GA18255@elte.hu>
Message-ID: <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
 <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
 <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com>
 <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru>
 <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
 <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
 <20070406191945.GA18255@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Ingo Molnar wrote:

> 
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > > > Ohhh, the "signal" struct! Funny name for something that nowadays 
> > > > has probably no more than a 5% affinity with signal-related tasks 
> > > > :/
> > > 
> > > Hmm.  I wonder if we should just rename it the struct thread_group, 
> > > or struct task_group.  Those seem slightly more accurate names.
> > 
> > Almost *anything* is better than "signal_struct" ;) A task_group could 
> > be fine, so something on the line of task_shared_ctx.
> 
> or lets just face it and name it what it is: process_struct ;-)

That'd be fine too! Wonder if Linus would swallow a rename patch like 
that...


- Davide


