Return-Path: <linux-kernel-owner+w=401wt.eu-S1765186AbYD0X1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765186AbYD0X1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYD0X1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:27:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYD0X1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:27:43 -0400
Message-ID: <48150BDA.5070903@redhat.com>
Date: Sun, 27 Apr 2008 16:27:22 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] eventfd, signalfd, timerfd, epoll_create w/flags
References: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com> <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0804271614240.18184@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:

> Ok, I asked this myself for about ten minutes, than I gave up. But why 
> sys_epoll_createp() instead of sys_epoll_create2()? There MUST be a reason 
> to deviate from the standard of all the other ones...

I used the number at the end for syscalls which aren't visible at
userlevel.  There they are useful indicating the number of arguments.
At userlevel I personally find it less than optimal but I'd have no
problem changing it to epoll_create2.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIFQva2ijCOnn/RHQRApYwAKCL4Ff6tZv+VyeuIMN6NHV1cCBhIACgvQRJ
YoZSN1dRdmarRhU0DzG0dbY=
=0nln
-----END PGP SIGNATURE-----
