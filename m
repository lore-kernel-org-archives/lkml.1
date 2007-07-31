Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbXGaG6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbXGaG6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbXGaG6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 02:58:39 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:7683 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbXGaG6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 02:58:37 -0400
Subject: Re: [ck] Re: SD still better than CFS for 3d ?
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Matthew Hawkins <darthmdh@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Christoph Hellwig <hch@infradead.org>,
       Jacob Braun <jwbraun@gmail.com>, kriko <kristjan.ugrin@gmail.com>,
       ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <b21f8390707302007n2f21018crc6b7cd83666e0f3c@mail.gmail.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
	 <20070729204716.GB1578@elte.hu>
	 <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
	 <20070730114649.GB19186@elte.hu> <op.tv90xghwatcbto@linux.site>
	 <d3380cee0707300831m33d896aufcbdb188576940a2@mail.gmail.com>
	 <b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com>
	 <20070730182959.GA29151@infradead.org> <adaps29sm62.fsf@cisco.com>
	 <b21f8390707302007n2f21018crc6b7cd83666e0f3c@mail.gmail.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 31 Jul 2007 09:01:48 +0200
Message-Id: <1185865308.4561.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 13:07 +1000, Matthew Hawkins wrote:
> On 7/31/07, Roland Dreier <rdreier@cisco.com> wrote:
> >  >      Fuck you Martin!
> >
> > I think you meant to yell at Matthew, not Martin ;)
> 
> What's amusing about this is he's yelling at me for something I didn't
> do, can't even get my name right, and has the audacity to claim that
> *I* am the one looking like a fool!  While we're descending into
> primary school theatrics, may I just say "takes one to know one" ;-)

Pouring oil into the fire ?

> I took the time to track down what caused a breakage - in an "illegal
> binary driver" (not against the law here, though defamation certainly
> is...) no less.  And contacted the vendor (separately).  Other people
> on desktop machines with an ATI card using the fglrx driver may have
> been interested to know that they can't do the benchmarking some
> people here on lkml and -mm are asking for with a current 2.6.23 git
> kernel, hence my post.

To inform the vendor and to post a warning about the issue on lkml was
the right thing to do. It is the wording of your post that obviously
irked some people.

> Martin's cleanup patch is good and I never claimed otherwise, I just
> said the comment on the commit was a bad call (as there are users of
> that interface).  Certainly ATI should fix their dodgy drivers.
> That's been the cry of the community for a long time...

The commit message could have been better. The correct thing to say
would have been "Nobody in the official kernel is using
ptep_test_and_clear_dirty and ptep_clear_flush_dirty."
nvidia will have to adapt their binary driver. This is not the first
time it breaks and it won't be the last time. We do not really have a
problem and we should all calm down and put that issue to rest.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


