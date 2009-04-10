Return-Path: <linux-kernel-owner+w=401wt.eu-S935763AbZDJNIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935763AbZDJNIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbZDJNHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:07:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53339 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbZDJNHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:07:54 -0400
Date: Fri, 10 Apr 2009 15:07:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090410130735.GC31307@elte.hu>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <87tz4x97uq.fsf@basil.nowhere.org> <alpine.LFD.2.00.0904090831000.4583@localhost.localdomain> <20090409184022.GA2665@elte.hu> <20090409193635.GO14687@one.firstfloor.org> <20090409211733.GA23233@elte.hu> <20090410003947.GA21681@brong.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410003947.GA21681@brong.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bron Gondwana <brong@fastmail.fm> wrote:

> > For example, if you have /home and / on separate reiser3 
> > filesystems, you could see as much as a 200% jump in performance 
> > straight away on certain workloads, on a dual-core box.
> > 
> > That big BKL overhead is a real reiser3 scalability problem - 
> > especially on reiser3 using servers which are likely to have 
> > several filesystems on the same box.
> 
> Yes - I'm certainly interested in that.
> 
> That said, we have a box with 83 reiserfs partitions on it, and 
> which is constrained by IO (main servers really don't need much 
> CPU).  Performance is pretty good even now.
> 
> So - I'm interested in this patch series, but not at the expense 
> of making reiserfs any less stable.  Our customers, funnily 
> enough, like it when our service is stable!

Definitely so :-)

	Ingo
