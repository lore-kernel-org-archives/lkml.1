Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbXB0LxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbXB0LxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933047AbXB0LxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:53:21 -0500
Received: from thunk.org ([69.25.196.29]:58184 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933044AbXB0LxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:53:20 -0500
Date: Tue, 27 Feb 2007 06:52:22 -0500
From: Theodore Tso <tytso@mit.edu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070227115221.GJ8154@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@zip.com.au>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Zach Brown <zach.brown@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Davide Libenzi <davidel@xmailserver.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227102832.GC23170@2ka.mipt.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 01:28:32PM +0300, Evgeniy Polyakov wrote:
> Obviously there are bugs, it is simply how things work.
> And debugging state machine code has exactly the same complexity as
> debugging multi-threading code - if not less...

Evgeniy,

I think what you are not hearing, and what everyone else is saying
(INCLUDING Linus), is that for most programmers, state machines are
much, much harder to program, understand, and debug compared to
multi-threaded code.  You may disagree (were you a MacOS 9 programmer
in another life?), and it may not even be true for you if you happen
to be one of those folks more at home with Scheme continuations, for
example.  But it is true that for most kernel programmers, threaded
programming is much easier to understand, and we need to engineer the
kernel for what will be maintainable for the majority of the kernel
development community.

Regards,

						- Ted
