Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYHXTnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYHXTnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 15:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYHXTnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 15:43:42 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59024 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYHXTnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 15:43:41 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Aug 2008 15:43:41 EDT
X-AuthUser: davidel@xmailserver.org
Date: Sun, 24 Aug 2008 12:35:33 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: No NONBLOCK flag for dup3() or epoll_create1()?
In-Reply-To: <48AC4B19.6000206@gmail.com>
Message-ID: <Pine.LNX.4.64.0808241229170.13864@alien.or.mcafeemobile.com>
References: <48AC4B19.6000206@gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Michael Kerrisk wrote:

> Ulrich
> 
> I've been doing some testing (2.6.27-rc3) of your new
> file-descriptor-creating syscalls that accept flags.  According to
> 
> http://udrepper.livejournal.com/20407.html
> 
> all of the system calls should accept a *_NONBLOCK flag.  All of them do,
> except for two:
> dup3(olfd, newfd, flags)
> and
> epoll_create1(flags).
> 
> For epoll_create1() this certainly appears to be an oversight, since I can't
> think of a reason not to support *_NONBLOCK.

Traditionally the no-wait epoll_wait() has been achieved with a zero 
timeout, but _NONBLOCK support can be easily added if seen as necessary.



- Davide


