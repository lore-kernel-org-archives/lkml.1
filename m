Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbXEFUSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbXEFUSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbXEFUSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:18:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2286 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbXEFUSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:18:49 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 6 May 2007 13:18:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ulrich Drepper <drepper@gmail.com>, Davi Arnaut <davi@haxent.com.br>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
In-Reply-To: <20070506125451.aac4b68f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705061309410.25331@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br>
 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
 <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
 <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
 <a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com>
 <Pine.LNX.4.64.0705051118030.19104@alien.or.mcafeemobile.com>
 <a36005b50705060050q512462edoe53efbc18f754471@mail.gmail.com>
 <20070506125451.aac4b68f.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007, Andrew Morton wrote:

> On Sun, 6 May 2007 00:50:47 -0700 "Ulrich Drepper" <drepper@gmail.com> wrote:
> 
> > > I really do not understand your point. You're too smart to not appreciate
> > > the beauty and the simmetry of objects that responds to a common interface
> > > (our files, win32 handles), and that fits our existing kernel infrastructure.
> > 
> > You're blinded by this symmetry.  Not everything that looks like a
> > good fit is a good idea.  This is one case.  Get over it, poll is not
> > powerful enough to serve as the unifying event mechanism.
> 
> What is your position on the timerfd/signalfd/etc patches?
> 
> Seems to me that if we were to have fancy new event-delivery machinery
> like kevent then the timerfd/signalfd work is heading in the other
> direction and ultimately would prove to have been unneeded?

Yes, of course. If we're heading to yet-another monolitic interface, we're 
heading with no valid reasons given if other than some handwaving. While 
there are quite a few (modularity, compatibilty, plus the other ones that 
came in my mind and that I explained in the way-too-many emails) to back a 
file-based approach.
Conversation with Uli, as often happen when arguing about software, got 
stuck. And since noone else seems interested in bringing valid points in 
one way or another, I'll leave the discussion as is, and I'll let you sort 
it out.



- Davide


