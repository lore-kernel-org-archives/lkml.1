Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbYEACaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbYEACaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYEAC3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:29:55 -0400
Received: from mail.crca.org.au ([67.207.131.56]:60861 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbYEAC3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:29:54 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: Slow DOWN, please!!!
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	 <20080430224610.GO8474@1wt.eu>
	 <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org>
	 <200805010242.36775.rjw@sisk.pl>
	 <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Thu, 01 May 2008 12:31:15 +1000
Message-Id: <1209609075.1271.19.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2008-04-30 at 18:40 -0700, Linus Torvalds wrote:
> The thing is, the quality of individual patches isn't what matters! What 
> matters is the quality of the end result. And people are going to be a lot 
> more involved in looking at, testing, and working with code that is 
> merged, rather than code that isn't.

No. People generally expect that code that has been merged does work, so
they don't look at it unless they're forced to (by a bug or the desire
to make further modifications in that code) and they don't explicitly
seek to test it. They just seek to use it.

When it doesn't work, some of us will go and seek to find the cause,
others (most?) will simply roll back to whatever they last found to be
reliable.

Out of tree code has the same issues.

The only time code really gets looked at and tested is when there's a
problem, or when people are explicitly choosing to inspect it (pre-merge
reviews, eg).

So my answer to the "how do we raise quality" question would be that
when writing the code, we put time and effort into properly analysing
the problem and developing a solution, we put time and effort into
carefully testing the solution, and we put code in that will help the
end-user help us to debug issues later (without them necessarily needing
to git-bisect). After all, good software isn't the result of random (or
semi-random), unconsidered modifications, but of planning, thought and
attention to detail.

In other words, I'm arguing that the speed of merging should be
irrelevant. What's relevant is the quality of the work done in the first
place.

If you want better quality code, penalise the people who get buggy code
merged. Give them a reason to get it in a better state before they try
to merge. Of course Linus alone can't do that.

Nigel

