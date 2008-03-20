Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYCTWwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYCTWwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYCTWwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:52:46 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:56069 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbYCTWwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:52:45 -0400
X-Trace: 683474503/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4IAK2H4kdRAVlC/2dsb2JhbACBWoFLqBU
Subject: Re: [PATCH] 1/2 Maple: Update bus driver to allow support of VMU
	device
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dwmw2@infradead.org, greg@kroah.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mtd@vger.kernel.org
In-Reply-To: <20080320153944.75b6edc1.akpm@linux-foundation.org>
References: <1205879413.6250.13.camel@localhost.localdomain>
	 <1205880554.6250.25.camel@localhost.localdomain>
	 <20080320135618.1a283b3e.akpm@linux-foundation.org>
	 <1206051797.6274.17.camel@localhost.localdomain>
	 <20080320153944.75b6edc1.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 22:52:27 +0000
Message-Id: <1206053547.6274.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-20 at 15:39 -0700, Andrew Morton wrote:
> On Thu, 20 Mar 2008 22:23:17 +0000
> Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> 
> > 
> > > urgh, down_trylock().  And a secret, undocumented one too.
> > > 
> > > A trylock is always an exceptional thing.  How is *any* reader of this code
> > > supposed to work out what the heck it's doing there?  Convert it into
> > > down(), run the code and decrypt the lockdep warnings, I suspect.
> > > 
> > > <looks>
> > > 
> > > Nope, I can't see any other lock being held when we call this function.
> > > 
> > > The trylocks are an utter mystery to me.  Please don't write mysterious
> > > code.
> > > 
> > 
> > OK, I am sure this is my problem but I have no idea why you are
> > describing down_trylock as undocumented
> 
> I'm describing your use of it!  I'm sitting here trying to work out why on
> earth this code is using the highly unusual (and highly suspicious) trylock
> idiom and this is far from clear.
> 

OK, I understand your point now. Some comments wouldn't go amiss, for
sure.

