Return-Path: <linux-kernel-owner+w=401wt.eu-S1032304AbXEHV0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032304AbXEHV0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968119AbXEHV0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:26:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967896AbXEHV0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:26:07 -0400
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
From: Dan Williams <dcbw@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       linville@tuxdriver.com, hch@infradead.org,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <4640E3BF.8080401@garzik.org>
References: <20070507141143.GB5125@tuxdriver.com>
	 <463F443A.5000306@garzik.org>
	 <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>
	 <20070508.132737.104034594.davem@davemloft.net>
	 <4640E3BF.8080401@garzik.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 17:29:23 -0400
Message-Id: <1178659763.14888.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 16:55 -0400, Jeff Garzik wrote:
> David Miller wrote:
> > From: "Pekka Enberg" <penberg@cs.helsinki.fi>
> >> On 5/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> >>> Open source is about release early, release often.  Not "hide code in a
> >>> dark corner until Christoph thinks it is perfect."  We have high
> >>> standards for upstream merged code, but that standard is not perfection.
> >> Please. This has nothing to do with Christoph. (1) the driver seems to
> >> break every Linux coding style convention known to man and (2) adds a
> >> new ABI with bunch of ioctls() that apparently haven't been reviewed
> >> properly. That's just not acceptable for mainline kernel!
> 
> > I completely agree, these things should be corrected and if the the
> > author is being totally unresponsive to Christoph's review that's even
> > worse.
> 
> Um, the maintainer replied yesterday morning[1] that libertas-2.6.git 
> has already been updated for these requests, will be updated some more, 
> and overall was responsive to the entire list of Christoph requests.
> 
> I'm mainly concerned with removing the unnecessary ioctls before 2.6.22 
> release, since that affects userspace.  The vast majority of other stuff 
> is cosmetic, which is being worked on, but lower priority in my book.

I'll audit the list of ioctls and remove ones that may be objectionable,
and we'll go back through them after 2.6.22 and add back in ones that
are actually required.  Keep the API/ABI small and expand if necessary.
What's the timeframe required here?  Linville said a few days at the
most.

Dan

