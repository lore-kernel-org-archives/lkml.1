Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXDXLM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXDXLM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbXDXLM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:12:29 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42205 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbXDXLM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:12:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] kthread: Enhance kthread_stop to abort interruptible sleeps
References: <20070413130236.GA173@tv-sign.ru>
	<m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
	<20070424030924.be44ebfa.akpm@linux-foundation.org>
	<m1r6qat681.fsf@ebiederm.dsl.xmission.com>
	<20070424034220.ca8d5d96.akpm@linux-foundation.org>
Date: Tue, 24 Apr 2007 05:11:06 -0600
In-Reply-To: <20070424034220.ca8d5d96.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 24 Apr 2007 03:42:20 -0700")
Message-ID: <m1mz0yt4c5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>
> Yes, it was fairly early in boot.  I didn't check what we're oopsing on.

Thanks.

It was definitely vfork_done == NULL from what I can read of the Oops and
the code.

> That was on a Fedora Core 3 machine.  One of those older distros I keep
> around to trip people up.

That could be something there.  Hopefully this is independent of compiler.
Otherwise it will suck to track down.

Eric



