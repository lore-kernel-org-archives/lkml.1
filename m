Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbXEQDQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbXEQDQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbXEQDQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:16:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612AbXEQDQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:16:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve.Hawkes@motorola.com
Subject: Re: [PATCH] recalc_sigpending_tsk fixes
In-Reply-To: Oleg Nesterov's message of  Thursday, 17 May 2007 03:43:20 +0400 <20070516234320.GB2144@tv-sign.ru>
Emacs: well, why *shouldn't* you pay property taxes on your editor?
Message-Id: <20070517031450.24E3E1F8509@magilla.localdomain>
Date: Wed, 16 May 2007 20:14:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We already discussed this, this is not so important, but how about
> 
> 	void recalc_sigpending_and_wake(struct task_struct *t)
> 	{
> 		int was_pending = signal_pending(t);
> 
> 		if (recalc_sigpending_tsk(t) && !was_pending)
> 			signal_wake_up(t, 0);
> 	}
> 
> ?
> 
> This "was_pending" is more a documenation than a optimization.

I don't object, but I think another comment about the wakeup being
sometimes superfluous is enough, if anything.  


Thanks,
Roland
