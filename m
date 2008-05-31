Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYEaEAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYEaEAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYEaD7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 23:59:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYEaD7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 23:59:49 -0400
Date: Fri, 30 May 2008 20:59:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
In-Reply-To: <4840C394.2080807@redhat.com>
Message-ID: <alpine.LFD.1.10.0805302056170.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301923020.3141@woody.linux-foundation.org> <4840C394.2080807@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Ulrich Drepper wrote:
> 
> In any case, robbing 64-bit architectures of the possible performance
> gain just because there are ancient versions which cannot do it is just
> plain stupid.  I know you cannot suggest that.

I'm suggesting that there are better approaches than forcing yet another 
new interface onto this thing. As mentioned, the kernel has had 32-bit 
rwsemaphores for a long time. Yes, there is "extra information" outside 
the 32-bit field, but I suspect you simply haven't looked hard enough at 
just using the existing futex code.

You certainly didn't even read - or understand - my emails, since you 
thought I was talking about regular semaphores and ignored the "rw" part 
entirely (not to mention the fact that I talked about reader counts etc, 
which is why I think you didn't even read the email).

		Linus
