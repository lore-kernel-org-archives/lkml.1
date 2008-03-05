Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbYCEBMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbYCEBMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYCEBL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:11:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYCEBLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:11:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] orphaned pgrp fixes
In-Reply-To: Oleg Nesterov's message of  Tuesday, 4 March 2008 18:51:13 +0300 <20080304155113.GC564@tv-sign.ru>
References: <20080302184430.GA16362@tv-sign.ru>
	<20080304122654.7313227010A@magilla.localdomain>
	<20080304155113.GC564@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080305011117.60EAA27010A@magilla.localdomain>
Date: Tue,  4 Mar 2008 17:11:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, SIGNAL_STOP_STOPPED doesn't relaible with ptrace. I mean, ptracer
> doesn't clear SIGNAL_STOP_STOPPED. This is btw one of the problems which
> complicates fixing do_wait(WSTOPPED).

We can clean that up too if you'd like to bring up the details.

> As for SIGNAL_STOP_STOPPING... I am dreaming to find the way to eliminate
> this lock-drop in get_signal_to_deliver(). Not sure this is possible, but
> it is so nasty. For example, SIGNAL_STOP_DEQUEUED is racy, and I don't know
> how to fix this. The patch we discussed some time ago doesn't really work
> because dequeue_signal() drops the lock too. The latter is fixable afaics,
> but needs very ugly changes.

It all certainly deserves more careful thought.


Thanks,
Roland
