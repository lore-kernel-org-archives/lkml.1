Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZBJXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZBJXNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbZBJXNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:13:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101AbZBJXNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:13:10 -0500
Date: Tue, 10 Feb 2009 15:12:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com
Subject: Re: [PATCH] mm: remove zone->prev_prioriy
Message-Id: <20090210151247.6747f66e.akpm@linux-foundation.org>
In-Reply-To: <28c262360902100257o6a8e2374v42f1ae906c53bcec@mail.gmail.com>
References: <20090210184055.6FCB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<28c262360902100257o6a8e2374v42f1ae906c53bcec@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 19:57:01 +0900
MinChan Kim <minchan.kim@gmail.com> wrote:

> As you know, prev_priority is used as a measure of how much stress page reclaim.
> But now we doesn't need it due to split-lru's way.
> 
> I think it would be better to remain why prev_priority isn't needed any more
> and how split-lru can replace prev_priority's role in changelog.
> 
> In future, it help mm newbies understand change history, I think.

Yes, I'd be fascinated to see that explanation.

In http://groups.google.pn/group/linux.kernel/browse_thread/thread/fea9c9a0b43162a1
it was asserted that we intend to use prev_priority again in the future.

We discussed this back in November:
http://lkml.indiana.edu/hypermail/linux/kernel/0811.2/index.html#00001

And I think that I still think that the VM got worse due to its (new)
failure to track previous state.  IIRC, the response to that concern
was quite similar to handwavy waffling.

