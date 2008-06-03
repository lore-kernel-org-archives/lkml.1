Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYFCV4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYFCV4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYFCV4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:56:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYFCV4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:56:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] s/PF_BORROWED_MM/PF_KTHREAD/
In-Reply-To: Oleg Nesterov's message of  Sunday, 1 June 2008 19:30:41 +0400 <20080601153041.GA8235@tv-sign.ru>
References: <20080601153041.GA8235@tv-sign.ru>
X-Windows: a mistake carried out to perfection.
Message-Id: <20080603215543.3230026FC96@magilla.localdomain>
Date: Tue,  3 Jun 2008 14:55:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like all three of these changes.  The 1/3 and 2/3 together constitute a
fix for the coredump vs aio race that is nice and clean.  The 2/2 is all
cleanup or possibly fixes more arcane cases we haven't enumerated yet.  
(I would have made that the last patch of the three.)  It merits some
follow-up looking at all (!task->mm) sorts of tests and making them use
a helper for what they really mean to express (e.g. is_kernel_thread()
if that's what they intend).


Thanks,
Roland
