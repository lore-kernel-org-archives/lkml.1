Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbXDFS1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbXDFS1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXDFS1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:27:05 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:52816 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773AbXDFS1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:27:03 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 6 Apr 2007 11:27:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] epoll cleanups - epoll include diet ...
In-Reply-To: <20070405182407.a785b895.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704061124570.8738@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.19972.1175650506.1>
 <20070405175905.733705cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704051806300.27713@alien.or.mcafeemobile.com>
 <20070405182407.a785b895.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, Andrew Morton wrote:

> On Thu, 5 Apr 2007 18:12:58 -0700 (PDT)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Thu, 5 Apr 2007, Andrew Morton wrote:
> > 
> > > epoll uses signal stuff and might need signal.h.  It implements syscalls
> > > and it certainly needs to have those syscall's prototypes in scope.  It
> > > surely uses stuff from mm.h (doesn't everything??)
> > 
> > Ack about signal.h, I forgot about the pwait code :(
> > Why syscalls.h? The eventpoll.c file expots syscalls, but it doesn't use 
> > anything declared in there.
> 
> So that the compiler can verify that our declarations of sys_epoll_foo()
> match our definitions of them.

Right. Just drop that patch then.



- Davide


