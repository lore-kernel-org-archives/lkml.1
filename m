Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbZE3OGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbZE3OGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758889AbZE3OGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:06:36 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:49041 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746AbZE3OGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:06:35 -0400
Date: Sat, 30 May 2009 07:04:15 -0700
From: "Larry H." <research@subreption.com>
To: pageexec@freemail.hu
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530140415.GC6535@oblivion.subreption.com>
References: <1243689707.6645.134.camel@laptop> <4A213AA8.18076.182E39C1@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A213AA8.18076.182E39C1@pageexec.freemail.hu>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:54 Sat 30 May     , pageexec@freemail.hu wrote:
> On 30 May 2009 at 15:21, Peter Zijlstra wrote:
> 
> > On Sat, 2009-05-30 at 13:42 +0200, pageexec@freemail.hu wrote:
> > > > Why waste time on this?
> > > 
> > > e.g., when userland executes a syscall, it 'can run kernel code'. if that kernel
> > > code (note: already exists, isn't provided by the attacker) gives unintended
> > > kernel memory back to userland, there is a problem. that problem is addressed
> > > in part by early sanitizing of freed data.
> > 
> > Right, so the whole point is to minimize the impact of actual bugs,
> > right?
> 
> correct. this approach is the manifestation of a particular philosophy
> in computer security where instead of finding all bugs, we minimize or,
> at times, eliminate their bad sideeffects. non-executable pages, ASLR,
> etc are all about this. see below why.
> 
> > So why not focus on fixing those actual bugs? Can we create tools
> > to help us find such bugs faster? We use sparse for a lot of static
> > checking, we create things like lockdep and kmemcheck to dynamically
> > find trouble.
> > 
> > Can we instead of working around a problem, fix the actual problem?
> 
> finding all use-after-free bugs is not possible, as far as i know. the
> fundamental problem is that you'd have to find bugs with arbitrary read
> sideeffects (which is just as hard a problem as finding bugs with arbitrary
> write sideeffects which you'd also have to solve). if you solve these
> problems, you'll have solved the most important bug class in computer
> security that many decades of academic/industrial/etc research failed at.

If Peter can pull this off, I'll ring the red phone and get some VC
contacts going. We will be driving Camaros in no time, and I will
finally ditch my Spyder before it puts an end to my adventure.

	Larry
