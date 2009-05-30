Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbZE3KqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbZE3KqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759071AbZE3Kp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:45:59 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:38550 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470AbZE3Kp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:45:58 -0400
Date: Sat, 30 May 2009 03:43:39 -0700
From: "Larry H." <research@subreption.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530104339.GA6535@oblivion.subreption.com>
References: <20090522143914.2019dd47@lxorguk.ukuu.org.uk> <20090522180351.GC13971@oblivion.subreption.com> <20090522192158.28fe412e@lxorguk.ukuu.org.uk> <20090522234031.GH13971@oblivion.subreption.com> <20090523090910.3d6c2e85@lxorguk.ukuu.org.uk> <20090523085653.0ad217f8@infradead.org> <1243539361.6645.80.camel@laptop> <20090529073217.08eb20e1@infradead.org> <20090530054856.GG29711@oblivion.subreption.com> <1243679973.6645.131.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243679973.6645.131.camel@laptop>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:39 Sat 30 May     , Peter Zijlstra wrote:
> > Because zero on allocate kills the very purpose of this patch and it has
> > obvious security implications. Like races (in information leak
> > scenarios, that is). What happens in-between the release of the page and
> > the new allocation that yields the same page? What happens if no further
> > allocations happen in a while (that can return the old page again)?
> > That's the idea.
> 
> I don't get it, these are in-kernel data leaks, you need to be able to
> run kernel code to exploit these, if someone can run kernel code, you've
> lost anyhow.
> 
> Why waste time on this?

If there were any hesitations about your lack of understanding in
security matters, you just cleared them all with the above statements.

> > > So if you zero on free, the next allocation will reuse the zeroed page.
> > > And due to LIFO that is not too far out "often", which makes it likely
> > > the page is still in L2 cache.
> > 
> > Thanks for pointing this out clearly, Arjan.
> 
> Thing is, the time between allocation and use is typically orders of
> magnitude less than between free and use. 
> 
> 
> Really, get a life, go fix real bugs. Don't make our kernel slower for
> wanking rights.

This is exactly the positive attitude, sound and mature response I was
expecting from you. Thank you.

	Larry
