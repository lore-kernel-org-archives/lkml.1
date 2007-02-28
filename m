Return-Path: <linux-kernel-owner+w=401wt.eu-S1751453AbXB1QOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbXB1QOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXB1QOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:14:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1418 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751453AbXB1QOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:14:34 -0500
Date: Wed, 28 Feb 2007 16:14:14 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070228161413.GA4319@ucw.cz>
References: <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227121116.GA31597@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I think what you are not hearing, and what everyone else is saying
> > (INCLUDING Linus), is that for most programmers, state machines are
> > much, much harder to program, understand, and debug compared to
> > multi-threaded code.  You may disagree (were you a MacOS 9 programmer
> > in another life?), and it may not even be true for you if you happen
> > to be one of those folks more at home with Scheme continuations, for
> > example.  But it is true that for most kernel programmers, threaded
> > programming is much easier to understand, and we need to engineer the
> > kernel for what will be maintainable for the majority of the kernel
> > development community.
> 
> I understand that - and I totally agree.
> But when more complex, more bug-prone code results in higher performance
> - that must be used. We have linked lists and binary trees - the latter

No-o. Kernel is not designed like that.

Often, more complex and slightly faster code exists, and we simply use
slower variant, because it is fast enough.

10% gain in speed is NOT worth major complexity increase.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
