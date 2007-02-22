Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbXBVJ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbXBVJ3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbXBVJ3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:29:30 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:16320 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbXBVJ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:29:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fn8DBFoHcLTx/jEBo98Gb4pgcxeuYlRbQycx+CPlxxNW5E45e0+kgQo7zPi+5byjnYrNI7sZvF+RxqNE/n4t3OGdy01hEa5EprYPit9HDzMGcQPMhij8U4llxKDai7AIOpqQLkH6DUTxj4Dy0dnckB2gB+sjc/cPPs/fsMSTpxI=
Message-ID: <f2b55d220702220129l2a596441k28f03fde252f72c3@mail.gmail.com>
Date: Thu, 22 Feb 2007 01:29:23 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070222070013.GA30921@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221233111.GB5895@elte.hu>
	 <f2b55d220702211704o549efd70oc0998cc663537ddd@mail.gmail.com>
	 <20070222070013.GA30921@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> the syslet/threadlet framework has been derived from Tux, which one can
> accuse of may things, but which i definitely can not accuse of being
> slow. It has no relationship whatsoever to Solaris 2.0 or later.

So how well does Tux fare on a NUMA box?  The Solaris 2.0 reference
was not about the origins of the code, it was about the era when SMP
first became relevant to the UNIX application programmer.  I remember
an emphasis on scheduler scalability then, too.  It took them quite a
while to figure out that having an efficient scheduler is of little
use if you are scheduling the wrong things on the wrong CPUs in the
wrong order and thereby thrashing continuously.  By that time we had
given up and gone back to message passing via the network stack, which
was the one kernel component that could figure out how to get state
from one CPU to another without taking all of its clothes off and
changing underwear in between.  Sound familiar?

> Your other mail showed that you have very basic misunderstandings about
> how threadlets work, on which you based a string of firm but incorrect
> conclusions. In this discussion i'm mostly interested in specific
> feedback about syslets/threadlets - thankfully we are past the years of
> "unless Linux does generic technique X it will stay a hobby OS forever"
> type of time-wasting discussions.

Well, maybe I'll let someone else weigh in about whether I understood
threadlets well enough to provide feedback worth reading.  As for the
"hobby OS forever" bit, that's an utter misrepresentation of my
comments and criticism.  Linux is now good enough for Oracle to have
more or less abandoned Sun for Linux.  That's as good as it needs to
be, as far as Oracle and IBM are concerned.  The question is now
whether it will ever get substantially _better_, so that you can do
something constructive with a NUMA box or a 64-core MIPS without
having the resources of an Oracle or a Google to build an
OS-atop-the-OS.

Cheers,
- Michael
