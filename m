Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbZE3OqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbZE3OqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbZE3OqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:46:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:32777 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119AbZE3OqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:46:16 -0400
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: pageexec@freemail.hu, "Larry H." <research@subreption.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20090530153023.45600fd2@lxorguk.ukuu.org.uk>
References: <20090522073436.GA3612@elte.hu>
	 <20090530054856.GG29711@oblivion.subreption.com>
	 <1243679973.6645.131.camel@laptop>
	 <4A211BA8.8585.17B52182@pageexec.freemail.hu>
	 <1243689707.6645.134.camel@laptop>
	 <20090530153023.45600fd2@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sat, 30 May 2009 16:45:37 +0200
Message-Id: <1243694737.6645.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 15:30 +0100, Alan Cox wrote:
> > Right, so the whole point is to minimize the impact of actual bugs,
> > right? So why not focus on fixing those actual bugs? Can we create tools
> > to help us find such bugs faster? We use sparse for a lot of static
> > checking, we create things like lockdep and kmemcheck to dynamically
> > find trouble.
> > 
> > Can we instead of working around a problem, fix the actual problem?
> 
> Why do cars have crashworthiness and seatbelts ? Why not fix the actual
> problem (driving errors) ? I mean lets face it they make the vehicle
> heavier, less fuel efficient, less fun and more annoying to use.

We can't find every crash bug either, yet we still ship the kernel and
people actually use it too.

What makes these security bugs so much more important than all the other
ones?

As to the kernel not knowing what might or might not be secure, that's
right, userspace proglet should take their bit of responsibility as
well, we can't fix this in the kernel alone.

As long as that openoffice or firefox instance keeps running, there's
nothing in the world the kernel can do to make it more secure.

If you really write documents that sekrit you simply shouldn't be using
such software but use an editor that is written by people as paranoid as
seems to be advocated here.



