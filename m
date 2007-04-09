Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXDII3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXDII3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 04:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXDII3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 04:29:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbXDII3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 04:29:04 -0400
Date: Mon, 9 Apr 2007 10:28:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070409082847.GA2228@elte.hu>
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com> <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com> <20070406191945.GA18255@elte.hu> <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 6 Apr 2007, Davide Libenzi wrote:
> > > 
> > > or lets just face it and name it what it is: process_struct ;-)
> > 
> > That'd be fine too! Wonder if Linus would swallow a rename patch like 
> > that...
> 
> I don't really see the point. It's not even *true*. A "process" 
> includes more than the shared signal-handling - it would include files 
> and fs etc too.
> 
> So it's actually *more* correct to call it the shared signal state 
> than it would be to call it "process" state.

we could call it "structure for everything that we know to be ugly about 
POSIX process semantics" ;-) The rest, like files and fs we've 
abstracted out already.

	Ingo
