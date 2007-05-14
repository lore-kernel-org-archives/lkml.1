Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbXENW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbXENW1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbXENW1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:27:46 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:42892 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756AbXENW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:27:45 -0400
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <4648DBE4.9000903@goop.org>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
	 <46489818.4000408@goop.org>
	 <20070514125946.0f74221c.akpm@linux-foundation.org>
	 <4648C062.5090704@goop.org>
	 <20070514133745.5bfc34ac.akpm@linux-foundation.org>
	 <1179176058.3703.85.camel@mulgrave.il.steeleye.com>
	 <20070514140530.8e0491cf.akpm@linux-foundation.org>
	 <4648D03F.4090407@goop.org>
	 <20070514145158.ca5f6174.akpm@linux-foundation.org>
	 <4648DBE4.9000903@goop.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 17:27:39 -0500
Message-Id: <1179181659.3703.99.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 15:00 -0700, Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
> > Well, let's get the build fix in place first and then we can feed
> > the cleanup in later on, in a more leisurely fashion?
> >   
> 
> If you like.  Are all the Voyager users standing outside your office
> with pitchforks, demanding satisfaction?

That could be arranged ...  The Xensource offices are just up the road
from Google, you know if I wanted to kill two birds with one stone.

Seriously, though, although I tolerate voyager breakage through the
merge window, I actively try to clean it up and have a working voyager
for the next release.  There's no real excuse for not fixing build
breakage.  How it's done, I don't really care.  The only blocker for the
two patch smp consolidation + voyager fix was Andi ... if he's relaxing
that, then we can go that route.

Until this is fixed, there are going to be -rc testers firing off build
failure reports, which I think we'd all like to 

James


