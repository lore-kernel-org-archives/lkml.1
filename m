Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbXENRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbXENRWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbXENRWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:22:35 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:34607 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877AbXENRWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:22:34 -0400
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <46489818.4000408@goop.org>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
	 <46489818.4000408@goop.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 12:22:28 -0500
Message-Id: <1179163348.3703.57.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 10:10 -0700, Jeremy Fitzhardinge wrote:
> James Bottomley wrote:
> > From: Jeremy Fitzhardinge <jeremy@xensource.com>
> > Subject: [VOYAGER] fix build broken by shift to smp_ops
> >
> > This adds an smp_ops for voyager, and hooks things up appropriately.
> > This is the first baby-step to making subarch runtime switchable.
> >
> > Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> >
> > Rediffed to work in the absence of the smp consolidation patch
> >   
> 
> I think Andrew is carrying that in -mm.  If you're proposing this for
> git, then we may as well pull in that patch too.

No, I'm proposing this for 2.6.22-rc1 ... Andi has already said he won't
push the smp consolidation patch for 2.6.22.

Without this patch, voyager won't even build, since the smp_ops broke
it, so it needs to be fixed *now*.

James


