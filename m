Return-Path: <linux-kernel-owner+w=401wt.eu-S934764AbXHOUtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbXHOUtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbXHOUtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:49:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:32975 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbXHOUtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:49:00 -0400
In-Reply-To: <alpine.LFD.0.999.0708160118330.16414@enigma.security.iitk.ac.in>
References: <46C2350A.1010807@redhat.com> <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <20070815081841.GA16551@osiris.boeblingen.de.ibm.com> <46C30540.2070603@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151941150.16414@enigma.security.iitk.ac.in> <20070815145207.GA23106@gondor.apana.org.au> <46C3253F.5090707@s5r6.in-berlin.de> <20070815162722.GD9645@linux.vnet.ibm.com> <d4406222873856f472b9173a14a19aa2@kernel.crashing.org> <20070815185724.GH9645@linux.vnet.ibm.com> <alpine.LFD.0.999.0708160118330.16414@enigma.security.iitk.ac.in>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <2d2eeab6276cab2e6cc5830d36a43b98@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: horms@verge.net.au, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, ak@suse.de,
       netdev@vger.kernel.org, cfriesen@nortel.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>, rpjday@mindspring.com,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, zlynx@acm.org,
       clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Wed, 15 Aug 2007 22:47:07 +0200
To: Satyam Sharma <satyam@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> What you probably mean is that the compiler has to assume any code
>>> it cannot currently see can do anything (insofar as allowed by the
>>> relevant standards etc.)
>
> I think this was just terminology confusion here again. Isn't "any code
> that it cannot currently see" the same as "another compilation unit",

It is not; try  gcc -combine  or the upcoming link-time optimisation
stuff, for example.

> and wouldn't the "compilation unit" itself expand if we ask gcc to
> compile more than one unit at once? Or is there some more specific
> "definition" for "compilation unit" (in gcc lingo, possibly?)

"compilation unit" is a C standard term.  It typically boils down
to "single .c file".


Segher

