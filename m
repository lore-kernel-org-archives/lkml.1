Return-Path: <linux-kernel-owner+w=401wt.eu-S1030787AbXCTA0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787AbXCTA0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030790AbXCTAZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:25:59 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51021 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030787AbXCTAZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:25:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 19 Mar 2007 17:24:43 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 2/13] signal/timer/event fds v7 - signalfd core ...
In-Reply-To: <20070320002205.GA338@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703191724150.3733@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.15249.1174348071.2>
 <20070320002205.GA338@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Oleg Nesterov wrote:

> On 03/19, Davide Libenzi wrote:
> >
> > +static void signalfd_unlock(struct signalfd_ctx *ctx,
> > +			    struct signalfd_lockctx *lk)
> > +{
> > +	unlock_task_sighand(lk->tsk, &lk->flags);
> > +}
> 
> Again, this is a matter of taste. But I can't understand why signalfd_unlock()
> needs "signalfd_ctx *ctx" parameter. If we have "struct signalfd_lockctx *lk",
> signalfd_lock() can setup lk->ctx if it is ever needed.

With the new API, I agree. Removed.



- Davide


