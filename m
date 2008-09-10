Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYIJVVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYIJVVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYIJVUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:20:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52908
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbYIJVUy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:20:54 -0400
Date: Wed, 10 Sep 2008 14:20:47 -0700 (PDT)
Message-Id: <20080910.142047.265458325.davem@davemloft.net>
To: david-b@pacbell.net
Cc: rdunlap@xenotime.net, akpm@linux-foundation.org,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       alessandro.zummo@towertech.it, tglx@linutronix.de
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809101419.05499.david-b@pacbell.net>
References: <20080910140417.bc35c199.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809101407490.7159@shark.he.net>
	<200809101419.05499.david-b@pacbell.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Wed, 10 Sep 2008 14:19:04 -0700

> On Wednesday 10 September 2008, Randy.Dunlap wrote:
> > 
> > > > > =============== CUT ON THE DOTTED LINE ==================
> > > > > Subject: ntp: let update_persistent_clock() sleep
> > > > > From: "Maciej W. Rozycki" <macro@linux-mips.org>
> > > > 
> > > > I see, as Paul mentioned this is needed for stuff like RTCs
> > > > behind I2C.
> > > > 
> > > > This change isn't in Linus's tree yet.
> > > 
> > > Should it be?
> 
> IMO if it doesn't make 2.6.27, it should merge for 2.6.28 early-ish.
> 
>  
> > > Its current status is: stuck in -mm.  I've sent it to Thomas a couple
> > > of times marked "for 2.6.27?" and he might have applied it now (I'm a
> > > few days behind, waiting for linux-next to start up again).
> > 
> > This is something that you can attempt (again) to address next week along
> > with other process issues...
> 
> I don't think anyone in particular has been _pushing_ to resolve these
> NTP related issues ... lack of urgency.  Maybe it's fair to think of
> that as a process issue.  If DaveM wants SPARC64 to completely remove
> its legacy RTC support for some release (which?) then:  (a) great! and
> (b) that should be sufficient urgency.

Well, firstly my RTC sparc work is 2.6.28 targetted.

Secondly, that sleeping capability is only really needed for I2C based
RTC chips, of which sparc isn't currently making any use of.

PowerPC folks do, however, use I2C based RTC chips right now I thought?
