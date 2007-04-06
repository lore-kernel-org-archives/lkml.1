Return-Path: <linux-kernel-owner+w=401wt.eu-S1750897AbXDFS6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbXDFS6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXDFS6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:58:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57993 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXDFS6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:58:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru>
	<Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
Date: Fri, 06 Apr 2007 12:56:57 -0600
In-Reply-To: <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
	(Davide Libenzi's message of "Fri, 6 Apr 2007 11:21:34 -0700 (PDT)")
Message-ID: <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> On Fri, 6 Apr 2007, Oleg Nesterov wrote:
>
>> Sure. It would be nice to move ->children into signal_struct at first.
>> Except this change breaks (in fact fixes) ->pdeath_signal behaviour.
>
> Ohhh, the "signal" struct! Funny name for something that nowadays has 
> probably no more than a 5% affinity with signal-related tasks :/

Hmm.  I wonder if we should just rename it the struct thread_group,
or struct task_group.  Those seem slightly more accurate names.

I remember last time the conversation about renaming it came up no
one had a good name for it that wasn't already taken.

Eric
