Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbXIDCZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbXIDCZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 22:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbXIDCYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 22:24:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXIDCYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 22:24:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? fix SIGNAL_STOP_DEQUEUED vs SIGCONT race
In-Reply-To: Oleg Nesterov's message of  Saturday, 1 September 2007 15:41:26 +0400 <20070901114126.GA243@tv-sign.ru>
X-Shopping-List: (1) Garden-variety longitude obsessions
   (2) Neoclassical exclamation nutrition
   (3) Aquatic distinguishers
   (4) Elevated fragrant insurgents
Message-Id: <20070904022416.D703F4D04CC@magilla.localdomain>
Date: Mon,  3 Sep 2007 19:24:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I also thought about something like this, but tried to avoid because
> it adds some complications. OTOH, this is not the fast path.

I agree it's not real pleasing, and would be glad to find better ideas.

> I'll try to think a bit more about this, and update the patch according
> to your comments. Looks like we don't need to check SIGNAL_GROUP_EXIT
> here, we are doing this later anyway.

I look forward to your next version.  


Thanks,
Roland
