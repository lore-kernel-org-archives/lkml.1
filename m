Return-Path: <linux-kernel-owner+w=401wt.eu-S1764111AbYD1AHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764111AbYD1AHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYD1AHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:07:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:34047 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYD1AHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:07:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 27 Apr 2008 17:07:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] eventfd, signalfd, timerfd, epoll_create w/flags
In-Reply-To: <48150BDA.5070903@redhat.com>
Message-ID: <Pine.LNX.4.64.0804271703470.18184@alien.or.mcafeemobile.com>
References: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com>
 <48150BDA.5070903@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Davide Libenzi wrote:
> 
> > Ok, I asked this myself for about ten minutes, than I gave up. But why 
> > sys_epoll_createp() instead of sys_epoll_create2()? There MUST be a reason 
> > to deviate from the standard of all the other ones...
> 
> I used the number at the end for syscalls which aren't visible at
> userlevel.  There they are useful indicating the number of arguments.
> At userlevel I personally find it less than optimal but I'd have no
> problem changing it to epoll_create2.

I think that an ending '2' at least has the logic behind of telling the 
number of parameters. A 'p' really doesn't say anything.
So it's either gonna be something like epoll_create_flags() or 
epoll_create2(). And between the two, I'd personally pick the latter.



- Davide


