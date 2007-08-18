Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXHRXZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXHRXZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 19:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757946AbXHRXZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 19:25:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbXHRXZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 19:25:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
In-Reply-To: Oleg Nesterov's message of  Saturday, 18 August 2007 21:40:01 +0400 <20070818174001.GA218@tv-sign.ru>
X-Shopping-List: (1) Ponderous perversion minions
   (2) Ambidextrous beatific rotation lions
   (3) Characteristic promotions
   (4) Dormant commotions
   (5) Sunburnt sleeves
Message-Id: <20070818232525.9B7554D05C6@magilla.localdomain>
Date: Sat, 18 Aug 2007 16:25:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe it can use wait_task_inactive, which IIUC is being changed to address
the same RT issue.  OTOH, notify_count exists only for this.  So maybe the
better way is to clean that whole mechanism up somehow.  The exit.c changes
in your patch seem to be making it more mysterious rather than less so.
I haven't really thought much about the better solution.


Thanks,
Roland
