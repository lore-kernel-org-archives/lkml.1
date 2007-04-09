Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXDIOha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXDIOha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933275AbXDIOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:37:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40682 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbXDIOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:37:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
References: <20070408155337.GA126@tv-sign.ru>
	<m1lkh23kkb.fsf@ebiederm.dsl.xmission.com>
	<20070408165750.GA149@tv-sign.ru>
	<m1d52e2w86.fsf@ebiederm.dsl.xmission.com>
	<20070409090643.GA121@tv-sign.ru>
	<20070409104302.GA14764@lnx-holt.americas.sgi.com>
Date: Mon, 09 Apr 2007 08:36:21 -0600
In-Reply-To: <20070409104302.GA14764@lnx-holt.americas.sgi.com> (Robin Holt's
	message of "Mon, 9 Apr 2007 05:43:02 -0500")
Message-ID: <m18xd13996.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

> I would say this is more a benefit than a problem.  With a couple of these
> systems we are testing, the number of kernel threads is far greater than
> the number of user processes and having pstree not normally show them, but
> maybe have an option we add later to show them again would be beneficial.

Sure.

Robin how many kernel thread per cpu are you seeing?

I don't know that we have a problem in this regard but it feels like
you are seeing a lot more kernel threads per cpu than I would expect
from looking at small systems.

I am wondering if somewhere we are using per cpu kernel threads when
we should not be...

Eric
