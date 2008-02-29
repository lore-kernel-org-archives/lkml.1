Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbYB2TUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbYB2TUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYB2TUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:20:47 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:41166 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYB2TUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:20:46 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 29 Feb 2008 11:20:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Passing epoll file descriptors across Unix domain sockets
In-Reply-To: <cfd18e0f0802290830y46d1b029hdcbbe2070f8d3773@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802291120000.31028@alien.or.mcafeemobile.com>
References: <cfd18e0f0802290830y46d1b029hdcbbe2070f8d3773@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008, Michael Kerrisk wrote:

> Hi Davide,
> 
> After all of the recent discussions about epoll, I've been reviewing
> other parts of the epoll.7 man page.  In that page there is the
> following:
> 
>        Q5  Can  I  send  the  epoll  file descriptor over a Unix
>            domain socket to another process?
> 
>        A5  No.
> 
> This does not seem accurate.  I can understand that it makes no sense
> to pass a an epoll file descriptor over a Unix domain socket, because
> the receiving process does not have the file descriptors that are in
> the epoll set.
> 
> However, it is indeed possible (no errors result) to pass an epoll fd
> over a Unix doman socket using SCM_RIGHTS.  (I have just now tested
> this.)
> 
> Can you clarify?  I suspect the text should really read:
> 
>        Q5  Can  I  send  an  epoll  file  descriptor over a Unix
>            domain socket to another process?
> 
>        A5  Yes, but it does not make sense to do this, since the
>            receiving  process  would not have copies of the file
>            descriptors in the epoll set.
> 
> Does that seem okay?

Looks okay to me.



- Davide


