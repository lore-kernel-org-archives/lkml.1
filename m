Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbXEIPrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbXEIPrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbXEIPq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:46:58 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45153 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbXEIPq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:46:57 -0400
Subject: Re: [patch] CFS scheduler, -v11
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
In-Reply-To: <20070508150431.GA26977@elte.hu>
References: <20070508150431.GA26977@elte.hu>
Content-Type: text/plain
Date: Wed, 09 May 2007 17:46:37 +0200
Message-Id: <1178725597.10077.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo.

Sorry it has taken this long, but i've been quite busy with work.

Here are my results with v11 for smoothness.

under slight load (spamasassin nice 19'ed), its now doing okay in
smoothness, almost as good as SD. but under harder load such as pressing
a link in a browser while 3d(at nice 0), or spamasassin at nice 0 still
makes it go stutterish instead of smooth. But overall it does seem
better.

On Tue, 2007-05-08 at 17:04 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > [...] Values 0x3 and 0xb are merely context switch happy.
> 
> thanks Mike - value 0x8 looks pretty good here and doesnt have the 
> artifacts you found. I've done a quick -v11 release with that fixed, 
> available at the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
> 
> with no other changes.
> 
> 	Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

