Return-Path: <linux-kernel-owner+w=401wt.eu-S1422838AbXCGSkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422838AbXCGSkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422987AbXCGSkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:40:17 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48076 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422838AbXCGSkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:40:15 -0500
Date: Wed, 7 Mar 2007 21:32:42 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Kirk Kuchov <kirk.kuchov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Davide Libenzi <davidel@xmailserver.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070307183242.GA29283@2ka.mipt.ru>
References: <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com> <20070303203140.GA756@2ka.mipt.ru> <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com> <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com> <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com> <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com> <20070306081935.GB2040@elf.ucw.cz> <ca9528de0703070402r3d189348t78d27cf3b80b4623@mail.gmail.com> <20070307173953.GA27603@elte.hu> <ca9528de0703071021t2aeb19d9ve537b0447cfd310@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <ca9528de0703071021t2aeb19d9ve537b0447cfd310@mail.gmail.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 07 Mar 2007 21:33:04 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 03:21:19PM -0300, Kirk Kuchov (kirk.kuchov@gmail.com) wrote:
> On 3/7/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >* Kirk Kuchov <kirk.kuchov@gmail.com> wrote:
> >
> >> I don't believe I'm wasting my time explaining this. They don't exist
> >> as /dev/null, they are just fucking _LINKS_.
> >[...]
> >> > Either stop flaming kernel developers or become one. It is that
> >> > simple.
> >>
> >> If I were to become a kernel developer I would stick with FreeBSD.
> >> [...]
> >
> >Hey, really, this is an excellent idea: what a boon you could become to
> >FreeBSD, again! How much they must be longing for your insightful
> >feedback, how much they must be missing your charming style and tactful
> >approach! I bet they'll want to print your mails out, frame them and
> >hang them over their fireplace, to remember the good old days on cold
> >snowy winter days, with warmth in their hearts! Please?
> >
> 
> http://www.totallytom.com/thecureforgayness.html

Fonts are a bit bad in my browser :)

Kirk, I understand your frustration - yes, Linux is not the perfect
place to include startups ideas, and yes it lacks some features modern
(or old) systems support for years, but things change with time.

I posted a patch which allows to poll for signals, it can be trivially
adopted to support timers and essentially any other events.
Kevent did that too, but some things are just too radical for immediate
support, especially when majority of users do not require additional
functionality.

People do work, and a lot of them do really good work, so no need for
rude talks about how things are bad. Things change - even I support
that, although kevent ignorance should put me into the first line with
you :)

Be good, and be cool.

> --
> Kirk Kuchov

-- 
	Evgeniy Polyakov
