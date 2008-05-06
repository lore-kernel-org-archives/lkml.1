Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbYEFXUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbYEFXUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbYEFXUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:20:04 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54064 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYEFXUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:20:02 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 May 2008 16:20:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Matthew Helsley <matthltc@us.ibm.com>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mtk.manpages@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 08/18] flag parameters: epoll_create
In-Reply-To: <cfd18e0f0805061610i48146b3fra3ac378643d51c9e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805061618460.25162@alien.or.mcafeemobile.com>
References: <200805050342.m453gk49029835@devserv.devel.redhat.com> 
 <1210107990.7323.347.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0805061540560.25162@alien.or.mcafeemobile.com>
 <cfd18e0f0805061610i48146b3fra3ac378643d51c9e@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Michael Kerrisk wrote:

> On Wed, May 7, 2008 at 12:41 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> >
> > On Tue, 6 May 2008, Matthew Helsley wrote:
> >
> > >
> > > On Sun, 2008-05-04 at 23:42 -0400, Ulrich Drepper wrote:
> > > > This patch adds the new epoll_create2 syscall.  It extends the old epoll_create
> > > > syscall by one parameter which is meant to hold a flag value.  In this
> > > > patch the only flag support is EPOLL_CLOEXEC which causes the close-on-exec
> > > > flag for the returned file descriptor to be set.
> > >
> > > Davide, Ulrich,
> > >
> > >       A minor question: Why did you choose to pass the seemingly useless
> > > "size" parameter into the new epoll_create2 system call? I did some
> > > googling for previous threads with this series and couldn't find a
> > > discussion on why you chose to keep it.
> >
> > The very first implementations were using an hash, and that was a size
> > hint.
> 
> So, why not simply remove this argument in the new API, since it is now useless?

I'm more than OK with that.



- Davide


