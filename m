Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYIQQwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYIQQwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYIQQvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:51:54 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:58928 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbYIQQvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:51:53 -0400
Date: Wed, 17 Sep 2008 20:46:54 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: mtk.manpages@gmail.com
Cc: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>, Alan Cox <alan@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@lst.de>
Subject: Re: sys_paccept: disable paccept() until API design is resolved
Message-ID: <20080917164654.GB12523@2ka.mipt.ru>
References: <48CFA10D.2010106@gmail.com> <48D03E85.9030808@redhat.com> <cfd18e0f0809161724w646b1e21s466afe74579f12e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0809161724w646b1e21s466afe74579f12e0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael.

On Wed, Sep 17, 2008 at 02:24:32AM +0200, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
> >> accept4(int fd, struct sockaddr *sa, socklen_t *salen, ind flags);
> >
> > The signal set wasn't actually my idea.  See:
> >
> > http://marc.info/?l=linux-kernel&m=120909788728078&w=2
> 
> [CC=+ Evgeniy Polyakov <johnpol@2ka.mipt.ru>]
> 
> But, what are you trying to say in pointing out that this wasn't your idea?

I asked to put signal mask there to be able to siplify life of those who
use accept() and signals. It is not 1005 _required_, but just like it is
not required to be in ppoll(). It is an optimization which should allow
to block signals during code execution without lots of additional steps
(like disabling/enabling them around the call via additional syscalls).

-- 
	Evgeniy Polyakov
