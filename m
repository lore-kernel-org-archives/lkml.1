Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbXEJJaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbXEJJaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXEJJaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:30:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:47428 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbXEJJaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:30:07 -0400
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, rusty@rustcorp.com.au
In-Reply-To: <20070510.015328.104645983.davem@davemloft.net>
References: <20070510003528.395b122b.akpm@linux-foundation.org>
	 <1178786505.14928.225.camel@localhost.localdomain>
	 <20070510015036.ebded3ac.akpm@linux-foundation.org>
	 <20070510.015328.104645983.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 10 May 2007 19:29:06 +1000
Message-Id: <1178789346.5575.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 01:53 -0700, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 10 May 2007 01:50:36 -0700
> 
> > We discussed this a couple of months back.  davem landed firmly in the
> > second camp and everyone then shut up ;)
> 
> No I landed in the first :-)))
> 
> I think the empty lines are a waste and only serve to eat
> up precious screen real-estate when reading code.
> 
> It is possible that I used to use the empty line thing in
> the past, but I definitely don't do that any more.

Yup, I used to do the other one too but nowadays, I much prefer not
wasting that additional line unless specific circumstances, like I
want a kind of "title" in front of a whole block of other definitions
with their own comments.

Something like:


/*
 * foo management stuff
 */


/* This puts the bar in the foo
 */
code code code code

/* This does something you don't want to know about
 */
code code code code


But does it realy matter that much ? :-)

Cheers,
Ben.


