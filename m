Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbXDJTRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbXDJTRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbXDJTRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:17:20 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4514 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbXDJTRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:17:19 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 10 Apr 2007 12:17:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Bill Davidsen <davidsen@tmr.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <461BA956.5010107@tmr.com>
Message-ID: <Pine.LNX.4.64.0704101215440.9017@alien.or.mcafeemobile.com>
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
 <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
 <20070406163100.GA554@tv-sign.ru> <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
 <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
 <20070406191945.GA18255@elte.hu> <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org>
 <20070409082847.GA2228@elte.hu> <461A816F.4050507@tmr.com>
 <9B6136A3-52B4-4AE2-9805-21634E25530A@mac.com>
 <Pine.LNX.4.64.0704091239030.6730@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704091302300.5940@alien.or.mcafeemobile.com> <461BA956.5010107@tmr.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007, Bill Davidsen wrote:

> Davide Libenzi wrote:
> > On Mon, 9 Apr 2007, Linus Torvalds wrote:
> > 
> > > On Mon, 9 Apr 2007, Kyle Moffett wrote:
> > > > Maybe "struct posix_process" is more descriptive?  "struct
> > > > process_posix"?
> > > > "Ugly POSIX process semantics data" seems simple enough to stick in a
> > > > struct
> > > > name.  "struct uglyposix_process"?
> > > Guys, you didn't read my message.
> > > 
> > > It's *not* about "process" stuff.  Anything that tries to call it a
> > > "process" is *by*definition* worse than what it is now. Processes have all
> > > the things that we've cleanly separated out for filesystem, VM, SysV
> > > semaphore state, namespaces etc.
> > > 
> > > The "struct signal_struct" is the random *leftovers* from all the other
> > > stuff. It's *not* about "processes". Never has been, and never will be. 
> > 
> > I proposed "struct task_shared_ctx" but you ducked :)
> > 
> Descriptive, correct, I like it!

He's stubborn, he'll never accept patches. Must be a seasonal thing ;)



- Davide


