Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZFCSh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZFCSh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZFCShv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:37:51 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:42517 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZFCShv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:37:51 -0400
Date: Wed, 3 Jun 2009 11:39:39 -0700
From: "Larry H." <research@subreption.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
	ZERO_SIZE_PTR to point at unmapped space)
Message-ID: <20090603183939.GC18561@oblivion.subreption.com>
References: <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <20090603182949.5328d411@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain> <20090603180037.GB18561@oblivion.subreption.com> <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:12 Wed 03 Jun     , Linus Torvalds wrote:
> 
> 
> On Wed, 3 Jun 2009, Larry H. wrote:
> > 
> > Are you saying that a kernel exploit can't be leveraged by means of
> > runtime code injection for example?
> 
> No. I'm sayng that sane people don't get hung up about every little 
> possibility.

Nothing of what has been mentioned is a little possibility. Far from it.

> Why are security people always so damn black-and-white? In most other 
> areas, such people are called "crazy" or "stupid", but the security people 
> seem to call them "normal".

Security people? I honestly share some of the opinions on the industry
that you might have, and I'm likely taking a gamble stating this
publicly.  You are right, there are bleeding imbeciles there. I'm not
part of that 'security people', and will never consider me one. My
interest on security, long time ago, started at the defensive side. I've
been doing kernel development for almost 5 years focusing on
developing _solutions_, not problems. Understanding the offensive side
in depth is a necessity if you want to be realistic on the defensive
one.

If I can help you understand it, and other kernel developers, to come to
a point where realistic, effective security improvements are deployed in
the kernel, we will have accomplished the one and only goal I had when I
started talking to riel or proposing patches.

> 
> The fact, the NULL pointer attack is neither easy nor common. It's 
> perfectly reasonable to say "we'll allow mmap at virtual address zero".

And how could you calibrate if this attack venue isn't easy to take
advantage of? Or not commonly abused? What empirical results led you to this
conclusion?

> Disallowing NULL pointer mmap's is one small tool in your toolchest, and 
> not at all all-consumingly important or fundamental. It's just one more 
> detail.

Definitely, another layer, part of a complex set of measures to deter
different kinds of flaws from all feasible sides. Fundamental to avoid
the situation it is designed to prevent. In the same way as changing
some pointers in the kernel for preventing unwise values to be used when
returning from 'unusual' code paths (kmalloc(0) for example).

> Get over it. Don't expect everybody to be as extremist as you apparently 
> are.

Extremism is the new buzzword. What's next? I'm not the one following up
with dogmatic responses lacking any reasoning. I've supported my claims
every time I expressed them so far. And when I was mistaken or agreed
with a different opinion, I made it clear as well.

Sorry, Linus, but you are taking a long shot calling people names.

	Larry
