Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbXHQWp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbXHQWp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXHQWpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:45:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:39401 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbXHQWpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:45:10 -0400
In-Reply-To: <alpine.LFD.0.999.0708170957350.3666@enigma.security.iitk.ac.in>
References: <20070809131423.GA9927@shell.boston.redhat.com> <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in> <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in> <20070815233721.91032366.billfink@mindspring.com> <alpine.LFD.0.999.0708161045360.25951@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0708161115370.25951@enigma.security.iitk.ac.in> <43eccf425e36943ce0411c3b504b1de2@kernel.crashing.org> <alpine.LFD.0.999.0708170957350.3666@enigma.security.iitk.ac.in>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <d14d1a768bfbbef34ee9f981cfd348c6@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Christoph Lameter <clameter@sgi.com>, heiko.carstens@de.ibm.com,
       horms@verge.net.au, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bill Fink <billfink@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       ak@suse.de, cfriesen@nortel.com, rpjday@mindspring.com,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, zlynx@acm.org,
       schwidefsky@de.ibm.com, Chris Snook <csnook@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Sat, 18 Aug 2007 00:38:12 +0200
To: Satyam Sharma <satyam@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Here, I should obviously admit that the semantics of *(volatile int 
>>> *)&
>>> aren't any neater or well-defined in the _language standard_ at all. 
>>> The
>>> standard does say (verbatim) "precisely what constitutes as access to
>>> object of volatile-qualified type is implementation-defined", but GCC
>>> does help us out here by doing the right thing.
>>
>> Where do you get that idea?
>
> Try a testcase (experimentally verify).

That doesn't prove anything.  Experiments can only disprove
things.

>> GCC manual, section 6.1, "When
>> is a Volatile Object Accessed?" doesn't say anything of the
>> kind.
>
> True, "implementation-defined" as per the C standard _is_ supposed to 
> mean
> "unspecified behaviour where each implementation documents how the 
> choice
> is made". So ok, probably GCC isn't "documenting" this
> implementation-defined behaviour which it is supposed to, but can't 
> really
> fault them much for this, probably.

GCC _is_ documenting this, namely in this section 6.1.  It doesn't
mention volatile-casted stuff.  Draw your own conclusions.


Segher

