Return-Path: <linux-kernel-owner+w=401wt.eu-S933157AbXB1RBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbXB1RBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbXB1RBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:01:32 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:3016 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157AbXB1RBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:01:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pj9EPwqZKDIuxP1qm6bnBcErRgW5ZrFzUqA9lpcVPEefYMuDzSbV9n5gLGr1Vf5nwv0oyz/BbYkh4D0z9cewePh4G6R2eLNMAztRpKPkr6Bq+s9mDOLqU0+cenauspbS5X6EDXsGhGR38VygCFIqjuNc3svMqqLbtFZprB9FH+U=
Message-ID: <f2b55d220702280901r421cc185mf669c3c7bf779531@mail.gmail.com>
Date: Wed, 28 Feb 2007 09:01:07 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Theodore Tso" <tytso@mit.edu>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070228080226.GA9639@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45DCD9E5.2010106@redhat.com> <20070222113148.GA3781@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
	 <20070226172812.GC22454@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
	 <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru>
	 <20070227115221.GJ8154@thunk.org>
	 <f2b55d220702271903o6bc418efu7d72a564a7ade365@mail.gmail.com>
	 <20070228080226.GA9639@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 130 lines skipped...

Yeah, I edited it down a lot before sending it.  :-)

> I have only one question - wasn't it too lazy to write all that? :)

I'm pretty lazy all right.  But occasionally an interesting problem
(and revamping AIO is very interesting) makes me think, and what
little thinking I do is always accompanied by writing.  Once I've
thought something through to the point that I think I understand the
problem, I've even been known to attempt a solution.  Not always,
though; more often, I find a new interesting problem, or else I am
forcibly reminded that I should be spending my little store of insight
on revenue-producing activity.

In this instance, there didn't seem to be any harm in sending my
thoughts to LKML as I wrote them, on the off chance that Ingo or
Davide would get some value out of them in this design cycle (which
any code I eventually get around to producing will miss).  So far,
I've gotten some rather dismissive pushback from Ingo and Alan (who
seem to have no interest outside x86 and less understanding than I
would have thought of what real userspace code looks like), a "why
preach to people who know more than you do" from Davide, a brief aside
on the dominance of x86 from Oleg, and one off-list "keep up the good
work".  Not a very rich harvest from (IMHO) pretty good seeds.

In short, so far the "Linux kernel community" is upholding its
reputation for insularity, arrogance, coding without prior design,
lack of interest in userspace problems, and inability to learn from
the mistakes of others.  (None of these characterizations depends on
there being any real insight in anything I have written.)  Linus
himself has a very different reputation -- plenty of arrogance all
right, but genuine brilliance and hard work, and sincere (if cranky)
efforts to explain the "theory of operations" underlying central
design choices.  So far he hasn't commented directly on anything I
have had to say; it will be interesting to see whether he tells me to
stop annoying the pros and to go away until I have some code to
contribute.

Happy hacking,
- Michael

P. S.  I do think "threadlets" are brilliant, though, and reading
Ingo's patches gave me a much better idea of what would be involved in
prototyping Asynchronously Executed I/O Unit opcodes.
