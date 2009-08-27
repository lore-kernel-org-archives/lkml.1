Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbZH0SfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbZH0SfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 14:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZH0SfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 14:35:10 -0400
Received: from sous-sol.org ([216.99.217.87]:34557 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751021AbZH0SfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 14:35:09 -0400
Date: Thu, 27 Aug 2009 11:29:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: stable-review@kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: Would it help to encourage users to read/test stable-review
	patches
Message-ID: <20090827182952.GC10360@sequoia.sous-sol.org>
References: <43e72e890908271122l6b08aaa5lc66de78301c7c88d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890908271122l6b08aaa5lc66de78301c7c88d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luis R. Rodriguez (mcgrof@gmail.com) wrote:
> We get development review eyes on stable patches during submission
> into a subsystem, and perhaps 1-2 user tests then. Typically patches
> are pretty easy to review for stable submission but I'm wondering
> about cases where things are not so clear and perhaps we want better
> testing and are less willing to take a fix into stable than on latest
> rc.

Typically in this case it's either too risky for -stable period, or
we ask for resubmission after it has had more time upstream (through
another -rc cycle, for example).

> Also what if a user just wants to test an entire series queues up
> for stable-review, is there a single all-in-one file user can just
> patch -p1 to help test prior to getting the next stable release made?

There is a queue that can be applied w/ quilt  (or any similar tool that
can handles patches + series file).  This is kept here:

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git

> Do we want more user exposure to stable-review mailing list or is just
> a few developer eyes enough?

More review never hurts, but do you think there's a specific lack or
problem?  Thanks for thinking about -stable ;-)

thanks,
-chris
