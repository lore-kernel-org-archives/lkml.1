Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXIRNO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXIRNO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 09:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXIRNOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 09:14:21 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38499 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbXIRNOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 09:14:20 -0400
Message-ID: <59750.145.64.134.222.1190121239.squirrel@www.hardeman.nu>
In-Reply-To: <1190115011.2995.126.camel@chaos>
References: <46EF7DDA.2070401@gmx.net> <46EF7E82.8040503@gmx.net>
    <1190106607.2995.97.camel@chaos> <20070918093007.223350@gmx.net>
    <1190108542.2995.112.camel@chaos> <20070918110841.235150@gmx.net>
    <1190115011.2995.126.camel@chaos>
Date: Tue, 18 Sep 2007 15:13:59 +0200 (CEST)
Subject: Re: RFC: A revised timerfd API
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Michael Kerrisk" <mtk-manpages@gmx.net>, davidel@xmailserver.org,
       drepper@redhat.com, geoff@gclare.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@lst.de, corbet@lwn.net,
       rdunlap@xenotime.net, vda.linux@googlemail.com,
       torvalds@linux-foundation.org, lee.schermerhorn@hp.com
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, September 18, 2007 13:30, Thomas Gleixner wrote:
>>>         timer_gettime(fd | POSIX_TIMER_FD, .....);
>
> If we use the most significant bit for POSIX_TIMER_FD, we should be
> fine.

I think alternative b) - three new syscalls, sounds better.

The only negatives so far are that it adds more syscalls and that it might
require code duplication with posix timers. The syscall numbers argument
seemed not to be very important and the code duplication should be fixable
by refactoring the code so that more is shared between the two systems (I
assume).

Overloading file descriptors with flags looks ugly, is there any other
syscall which does that?

-- 
David Härdeman
(sorry Thomas for the dupe, I missed replying to all on the first msg).


