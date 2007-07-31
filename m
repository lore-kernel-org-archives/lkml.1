Return-Path: <linux-kernel-owner+w=401wt.eu-S967261AbXGaDHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967261AbXGaDHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965949AbXGaDHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:07:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:19914 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965745AbXGaDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EW5Olgn+NnRVPzZc/+WZkJWSte2Z2Htg18xC+4eXWtt2ESn/B8XoMlvgJqrPMk9lBlqIoXqsmea3W8Gl1ABU9cBAmYgUIm99pxDYDoX3z7g2uSD8MZ6BmWHpQ3Y3/RYCZRTspkTG1tGK9uNe2lN1CWHMwFBF11oJT9Lj+0rbcgY=
Message-ID: <b21f8390707302007n2f21018crc6b7cd83666e0f3c@mail.gmail.com>
Date: Tue, 31 Jul 2007 13:07:30 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?
Cc: "Christoph Hellwig" <hch@infradead.org>, "Jacob Braun" <jwbraun@gmail.com>,
       kriko <kristjan.ugrin@gmail.com>, ck@vds.kolivas.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "Martin Schwidefsky" <schwidefsky@de.ibm.com>
In-Reply-To: <adaps29sm62.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
	 <20070729204716.GB1578@elte.hu>
	 <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
	 <20070730114649.GB19186@elte.hu> <op.tv90xghwatcbto@linux.site>
	 <d3380cee0707300831m33d896aufcbdb188576940a2@mail.gmail.com>
	 <b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com>
	 <20070730182959.GA29151@infradead.org> <adaps29sm62.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Roland Dreier <rdreier@cisco.com> wrote:
>  >      Fuck you Martin!
>
> I think you meant to yell at Matthew, not Martin ;)

What's amusing about this is he's yelling at me for something I didn't
do, can't even get my name right, and has the audacity to claim that
*I* am the one looking like a fool!  While we're descending into
primary school theatrics, may I just say "takes one to know one" ;-)

I took the time to track down what caused a breakage - in an "illegal
binary driver" (not against the law here, though defamation certainly
is...) no less.  And contacted the vendor (separately).  Other people
on desktop machines with an ATI card using the fglrx driver may have
been interested to know that they can't do the benchmarking some
people here on lkml and -mm are asking for with a current 2.6.23 git
kernel, hence my post.

Martin's cleanup patch is good and I never claimed otherwise, I just
said the comment on the commit was a bad call (as there are users of
that interface).  Certainly ATI should fix their dodgy drivers.
That's been the cry of the community for a long time...

-- 
Matt
