Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbYJ0BXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbYJ0BXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 21:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYJ0BXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 21:23:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:44577 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYJ0BXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 21:23:38 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 26 Oct 2008 18:23:36 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Paul P <ppak_98@yahoo.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: unexpected extra pollout events from epoll
In-Reply-To: <Pine.LNX.4.64.0810261812510.19212@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0810261822040.19212@alien.or.mcafeemobile.com>
References: <107660.83879.qm@web56306.mail.re3.yahoo.com>
 <Pine.LNX.4.64.0810261812510.19212@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008, Davide Libenzi wrote:

> On Sun, 26 Oct 2008, Paul P wrote:
> 
> > However, I get strange behavior when I tried adding fd's with only the 
> > EPOLLIN interest mask. If I use epoll_wait with both the EPOLLIN and 
> > EPOLLOUT interest mask, but add fd's with only the EPOLLIN interest mask,
> > I still seem to get EPOLLOUT events on the fd.
> 
> Again, how the heck do you "use epoll_wait with both the EPOLLIN and 
> EPOLLOUT"?!? There is not such a thing.

Wait? It's not that you pass EPOLLIN or EPOLLOUT to the "maxevents" 
parameter of epoll_wait()?
That's the maximum event count you want to fetch, not an event mask.



- Davide


