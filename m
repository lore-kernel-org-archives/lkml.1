Return-Path: <linux-kernel-owner+w=401wt.eu-S1763071AbZE1LvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763071AbZE1LvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZE1LvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:51:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39645 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755520AbZE1LvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:51:04 -0400
Date: Thu, 28 May 2009 12:50:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>, "Larry H." <research@subreption.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       pageexec@freemail.hu, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090528125042.28c2676f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090528090836.GB6715@elte.hu>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<4A15A8C7.2030505@redhat.com>
	<20090522073436.GA3612@elte.hu>
	<20090522113809.GB13971@oblivion.subreption.com>
	<20090523124944.GA23042@elte.hu>
	<4A187BDE.5070601@redhat.com>
	<20090527223421.GA9503@elte.hu>
	<20090528072702.796622b6@lxorguk.ukuu.org.uk>
	<20090528090836.GB6715@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > In most respects the benchmarks are pretty irrelevant - wiping 
> > stuff has a performance cost, but its the sort of thing you only 
> > want to do when you have a security requirement that needs it. At 
> > that point the performance is secondary.
> 
> Bechmarks, of course, are not irrelevant _at all_.
> 
> So i'm asking for this "clear kernel stacks on freeing" aspect to be 
> benchmarked thoroughly, as i expect it to have a negative impact - 
> otherwise i'm NAK-ing this. 

Ingo you are completely missing the point

The performance cost of such a security action are NIL when the feature
is disabled. So the performance cost in the general case is irrelevant.

If you need this kind of data wiping then the performance hit
is basically irrelevant, the security comes first. You can NAK it all you
like but it simply means that such users either have to apply patches or
run something else.

If it harmed general user performance you'd have a point - but its like
SELinux you don't have to use it if you don't need the feature. Which it
must be said is a lot better than much of the scheduler crud that has
appeared over time which you can't make go away.
