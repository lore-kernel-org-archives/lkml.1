Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZBKLHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZBKLHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 06:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZBKLGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 06:06:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36166 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZBKLGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 06:06:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: remove zone->prev_prioriy
Cc: kosaki.motohiro@jp.fujitsu.com, MinChan Kim <minchan.kim@gmail.com>,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, riel@redhat.com
In-Reply-To: <20090210151247.6747f66e.akpm@linux-foundation.org>
References: <28c262360902100257o6a8e2374v42f1ae906c53bcec@mail.gmail.com> <20090210151247.6747f66e.akpm@linux-foundation.org>
Message-Id: <20090211195252.C3BD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 11 Feb 2009 20:06:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 10 Feb 2009 19:57:01 +0900
> MinChan Kim <minchan.kim@gmail.com> wrote:
> 
> > As you know, prev_priority is used as a measure of how much stress page reclaim.
> > But now we doesn't need it due to split-lru's way.
> > 
> > I think it would be better to remain why prev_priority isn't needed any more
> > and how split-lru can replace prev_priority's role in changelog.
> > 
> > In future, it help mm newbies understand change history, I think.
> 
> Yes, I'd be fascinated to see that explanation.
> 
> In http://groups.google.pn/group/linux.kernel/browse_thread/thread/fea9c9a0b43162a1
> it was asserted that we intend to use prev_priority again in the future.
> 
> We discussed this back in November:
> http://lkml.indiana.edu/hypermail/linux/kernel/0811.2/index.html#00001
> 
> And I think that I still think that the VM got worse due to its (new)
> failure to track previous state.  IIRC, the response to that concern
> was quite similar to handwavy waffling.

Yes.
I still think it's valuable code.
I think, In theory, VM sould take parallel reclaim bonus.

However, recently, KAMEZAWA-san reported memcg prev_priority code are
busted due to hierarchical-memory-reclaim and he dislike maintain 
unused function.

http://marc.info/?l=linux-mm&m=123258289017433&w=2


and, at that time I can't show good example workload of parallel reclaim bonus
effective.
Therefore I agreed to drop this and insert it again at re-using time ;-)



