Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbXEJLiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbXEJLiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbXEJLiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:38:07 -0400
Received: from [209.180.55.243] ([209.180.55.243]:51007 "EHLO
	jdub.homelinux.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbXEJLiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:38:06 -0400
X-Greylist: delayed 1773 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 07:38:06 EDT
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
From: Josh Boyer <jwboyer@jdub.homelinux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <1178789346.5575.2.camel@localhost.localdomain>
References: <20070510003528.395b122b.akpm@linux-foundation.org>
	 <1178786505.14928.225.camel@localhost.localdomain>
	 <20070510015036.ebded3ac.akpm@linux-foundation.org>
	 <20070510.015328.104645983.davem@davemloft.net>
	 <1178789346.5575.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 06:01:03 -0500
Message-Id: <1178794863.11271.20.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 19:29 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2007-05-10 at 01:53 -0700, David Miller wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Date: Thu, 10 May 2007 01:50:36 -0700
> > 
> > > We discussed this a couple of months back.  davem landed firmly in the
> > > second camp and everyone then shut up ;)
> > 
> > No I landed in the first :-)))
> > 
> > I think the empty lines are a waste and only serve to eat
> > up precious screen real-estate when reading code.
> > 
> > It is possible that I used to use the empty line thing in
> > the past, but I definitely don't do that any more.
> 
> Yup, I used to do the other one too but nowadays, I much prefer not
> wasting that additional line unless specific circumstances, like I
> want a kind of "title" in front of a whole block of other definitions
> with their own comments.
> 
> Something like:
> 
> 
> /*
>  * foo management stuff
>  */
> 
> 
> /* This puts the bar in the foo
>  */
> code code code code
> 
> /* This does something you don't want to know about
>  */
> code code code code

Now your examples are just wrong.  One liners should be:

/* This puts the bar in the foo */

Are we having fun yet? ;)

/me goes to look for something better to do

josh

