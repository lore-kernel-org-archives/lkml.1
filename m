Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXDIUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXDIUBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbXDIUBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:01:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52839 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965337AbXDIUBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:01:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru>
	<Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
	<m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
	<20070406191945.GA18255@elte.hu>
	<Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com>
	<Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org>
	<20070409082847.GA2228@elte.hu> <461A816F.4050507@tmr.com>
	<9B6136A3-52B4-4AE2-9805-21634E25530A@mac.com>
Date: Mon, 09 Apr 2007 14:00:38 -0600
In-Reply-To: <9B6136A3-52B4-4AE2-9805-21634E25530A@mac.com> (Kyle Moffett's
	message of "Mon, 9 Apr 2007 15:28:44 -0400")
Message-ID: <m1irc51fo9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <mrmacman_g4@mac.com> writes:

> Maybe "struct posix_process" is more descriptive?  "struct process_posix"?
> "Ugly POSIX process semantics data" seems simple  enough to stick in a struct
> name.  "struct uglyposix_process"?

Nack.

Linux internally doesn't have processes it has tasks with different
properties.  Anything that talks about processes will be even more
confusing.

The only thing really wrong with struct signal is that it is easy to
confuse with struct sighand.

Eric
