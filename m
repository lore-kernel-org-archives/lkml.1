Return-Path: <linux-kernel-owner+w=401wt.eu-S933865AbXEHGab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865AbXEHGab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXEHGa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:30:27 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1786 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbXEHGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:30:20 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 7 May 2007 23:30:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <a36005b50705071949r4f45194bhc0c0416db28d1560@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705072324270.4247@alien.or.mcafeemobile.com>
References: <20070504225730.490334000@haxent.com.br>  <463BC3CA.6050109@haxent.com.br>
  <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com> 
 <463CFA37.3020809@haxent.com.br>  <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
  <463F9B68.305@haxent.com.br>  <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
  <Pine.LNX.4.64.0705071525200.29173@alien.or.mcafeemobile.com>
 <a36005b50705071949r4f45194bhc0c0416db28d1560@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Ulrich Drepper wrote:

> On 5/7/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > read(2) is a cancellation point too. So if the fine userspace code issues
> > a random pthread_cancel() to a thread handling that, data is lost together
> > with the session that thread was handling.
> 
> This is absolutely not comparable.  When read/write is canceled no
> data is lost.  Some other thread might have to pick up the slack but
> that's it.

Ohh, is it different? Please, it is not even worth to show you how exactly 
the same is. Because you are perfectly aware of it.


> We went over this for kevent discussions.  I really am not willing to
> do it all again especially since there is no hope to achieve a
> satisfying result with poll.  So, don't count my silence as agreement,
> it isn't.

You're climbing mirrors AFAICS, more that bringing any valid points. And 
as far as I'm concerned, this thread is becoming very repetitive and boring.



- Davide


