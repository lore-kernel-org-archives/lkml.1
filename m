Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXCSAYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXCSAYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 20:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXCSAYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 20:24:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50630 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934AbXCSAYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 20:24:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 18 Mar 2007 17:22:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
In-Reply-To: <200703190045.24605.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0703181720410.5482@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
 <200703172235.09227.arnd@arndb.de> <Pine.LNX.4.64.0703181313460.5482@alien.or.mcafeemobile.com>
 <200703190045.24605.arnd@arndb.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Arnd Bergmann wrote:

> On Sunday 18 March 2007, Davide Libenzi wrote:
> > bah, __put_user is basically a move, so I don't think that efficency would 
> > be that different (assuming that it'd matter in this case). The only thing 
> > many __put_user do, is increase the exception table sizes.
> 
> The cost of user access functions varies a lot depending on the
> architectures. Those platforms with a 4G/4G split e.g. need to do more
> than a simple move, and for s390 it may even come down to an indirect
> function call, which incurs significant register pressure.

Heh, I'd like ppl to agree on this, because I clearly remember in having 
an argoument with Andrew for the same thing, where I was doing stack setup 
plus copy_to_user() ;)



- Davide


