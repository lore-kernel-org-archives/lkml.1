Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYIJVTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYIJVTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYIJVTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:19:10 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:28736 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752765AbYIJVTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:19:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RkfZ5GYbHWkWpJWdWPaNy4yMicxAGlzB/Mjht+kqX56tplwkhzyn7xlTqXIsxdCXsfBMIjkF+YaRS1rohWUEYObqzQZWc73Ss1HEIU3cQ6gZ/DWRz/An2wEw0SN2VbByIf3kucQ9M3tbzWpCWVtaBhUzJpRsfKeVdNb3UlO+fjU=  ;
X-YMail-OSG: uaBijWYVM1lqMgO_o56zE0kyKvgUJ.Nstcw9JqxWqMZzcsAfovGZlXmRhiBuz0gm3FyxWjy.uBsUz0QlC9e13qh8TlQm_vi9U7VQydemuqkzZQLD14OEBbyGrY5dpQU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Wed, 10 Sep 2008 14:19:04 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       alessandro.zummo@towertech.it, Thomas Gleixner <tglx@linutronix.de>
References: <200809081629.21125.david-b@pacbell.net> <20080910140417.bc35c199.akpm@linux-foundation.org> <Pine.LNX.4.64.0809101407490.7159@shark.he.net>
In-Reply-To: <Pine.LNX.4.64.0809101407490.7159@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809101419.05499.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008, Randy.Dunlap wrote:
> 
> > > > =============== CUT ON THE DOTTED LINE ==================
> > > > Subject: ntp: let update_persistent_clock() sleep
> > > > From: "Maciej W. Rozycki" <macro@linux-mips.org>
> > > 
> > > I see, as Paul mentioned this is needed for stuff like RTCs
> > > behind I2C.
> > > 
> > > This change isn't in Linus's tree yet.
> > 
> > Should it be?

IMO if it doesn't make 2.6.27, it should merge for 2.6.28 early-ish.

 
> > Its current status is: stuck in -mm.  I've sent it to Thomas a couple
> > of times marked "for 2.6.27?" and he might have applied it now (I'm a
> > few days behind, waiting for linux-next to start up again).
> 
> This is something that you can attempt (again) to address next week along
> with other process issues...

I don't think anyone in particular has been _pushing_ to resolve these
NTP related issues ... lack of urgency.  Maybe it's fair to think of
that as a process issue.  If DaveM wants SPARC64 to completely remove
its legacy RTC support for some release (which?) then:  (a) great! and
(b) that should be sufficient urgency.

There was, I think, another patch related to this one.  Then there may
be a few other loose ends to tie up also.

- Dave
