Return-Path: <linux-kernel-owner+w=401wt.eu-S934373AbXEGPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373AbXEGPXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbXEGPXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:23:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46242 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934289AbXEGPXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:23:12 -0400
Message-ID: <463F443A.5000306@garzik.org>
Date: Mon, 07 May 2007 11:22:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Dan Williams <dcbw@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6 (was Re:
 Please pull 'libertas' branch of wireless-2.6)
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070507104117.GA31601@infradead.org> <1178539423.3032.24.camel@localhost.localdomain> <20070507141143.GB5125@tuxdriver.com>
In-Reply-To: <20070507141143.GB5125@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> On Mon, May 07, 2007 at 08:03:43AM -0400, Dan Williams wrote:
>> On Mon, 2007-05-07 at 11:41 +0100, Christoph Hellwig wrote:
> 
>>> Of course it's not anywhere near good shape.  Almost all items from my
>>> review were completely ignored, and we have another totoally substandard
>>> wireless driver with crappy thread handling, a huge number of broken private
>>> ioctls and partially absymal codingstyle.
> 
>> I've already updated libertas-2.6 git with a ton of updates for this.
>>
>> In any case, lets push off any merge until 2.6.23 so the rest of the
>> comments can be dealt with:
> 
> Alright...Jeff, would you please pull the following branch for upstream ASAP:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git revert-libertas

This is leading from behind :/  We don't need to blow about in the wind 
here.  If you reviewed the driver in depth -- which I assumed because of 
the trust placed in you as wireless maintainer -- then this situation 
really should not be happening.  You need to know the status of new 
drivers you are pushing upstream: what work is left to do, what has been 
done, what state the driver is in.

I view this request as a failure of the trust network :(

For my part, I _did_ review it.  Twice.  Once in the early days, and 
once when I pulled it into my netdev-2.6.git tree.  libertas needs the 
changes mentioned in this thread.  But the driver is in workable shape 
to be USED while being improved.  I strongly dislike people being cowed 
into not merging a driver for years, because the driver in question does 
not meet Christoph's idea of perfection.

Open source is about release early, release often.  Not "hide code in a 
dark corner until Christoph thinks it is perfect."  We have high 
standards for upstream merged code, but that standard is not perfection. 
  Perfect is the enemy of good.

I would rather see the libertas-2.6 git changes pulled into upstream, 
and am not inclined to revert a WORKING DRIVER at this point, a driver 
that is actively maintained and has seen quite a bit of improvement 
since it initially appeared.

IMO, Linux users best served by avoiding this silly song and dance, now 
that the driver is upstream.

Plus, that leaves the kernel history less polluted.

	Jeff




