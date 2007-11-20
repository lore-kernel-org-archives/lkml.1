Return-Path: <linux-kernel-owner+w=401wt.eu-S1763777AbXKTWdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777AbXKTWdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbXKTWdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:33:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43489 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327AbXKTWdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:33:42 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 20 Nov 2007 14:33:13 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Zach Brown <zach.brown@oracle.com>,
       Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
In-Reply-To: <20071120222227.GH24156@elte.hu>
Message-ID: <Pine.LNX.4.64.0711201431490.15098@alien.or.mcafeemobile.com>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com>
 <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com>
 <474323CA.9030306@zytor.com> <47432666.6070503@oracle.com> <474331B7.6020802@zytor.com>
 <20071120222227.GH24156@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Ingo Molnar wrote:

> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > It seems that you're doing the same thing in both cases, except you're 
> > now extending it to include other random functionality, which means 
> > other things than syslets are suddenly affected.
> >
> > syslets are arguably a little bit different, since what you're 
> > effectively doing there is running a miniature interpreted language in 
> > kernel space.  A higher startup overhead should be acceptable, since 
> > you're amortizing it over a larger number of calls.  Extending that 
> > mechanism suddenly means you HAVE to use that interpreted language 
> > message mechanism to access certain system calls, which really does 
> > not seem like a good thing neither for performance nor for encouraging 
> > sane design of interfaces.
> 
> whether that interpreted syslet language survives is still an open 
> question - it was extremely ugly when i wrote the first version of it 
> and it only got uglier since then :-)

Aha! You admitted it finally :)



- Davide


