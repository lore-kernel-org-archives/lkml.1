Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYEEE47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYEEE47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYEEE4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:56:48 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54284 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYEEE4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:56:47 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 May 2008 21:56:46 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mtk.manpages@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 04/18] flag parameters: anon_inode_getfd extension
In-Reply-To: <200805050342.m453gktV029823@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0805042156010.8307@alien.or.mcafeemobile.com>
References: <200805050342.m453gktV029823@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, Ulrich Drepper wrote:

> This patch just extends the anon_inode_getfd interface to take an additional
> parameter with a flag value.  The flag value is passed on to
> get_unused_fd_flags in anticipation for a use with the O_CLOEXEC flag.
> 
> No actual semantic changes here, the changed callers all pass 0 for now.
> 
> 
>  fs/anon_inodes.c            |    9 +++++----
>  fs/eventfd.c                |    2 +-
>  fs/eventpoll.c              |    2 +-
>  fs/signalfd.c               |    3 ++-
>  fs/timerfd.c                |    2 +-
>  include/linux/anon_inodes.h |    2 +-
>  6 files changed, 11 insertions(+), 9 deletions(-)
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


