Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYHAQZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYHAQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYHAQZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:25:51 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:59532 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbYHAQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:25:50 -0400
Date: Fri, 1 Aug 2008 12:25:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ryan Hope <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: reiser4 for 2.6.27-rc1
Message-ID: <20080801162548.GD8654@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ryan Hope <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>
References: <48f7fe350808010649l1111f48enbb6eca3cfcbba67f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350808010649l1111f48enbb6eca3cfcbba67f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 09:49:55AM -0400, Ryan Hope wrote:
> Why is reiser4 still not in a vanilla kernel for testing. I have had
> to apply the reiser4 patches from -mm kernels to vanilla based
> patchset for over a year now. Reiser4 works fine, what will it take to
> get it included in vanilla? Here is a patch to add reiser4 to
> 2.6.27-rc1:
> 
> http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch

The reasons laid out in these web pages haven't changed.

http://kernelnewbies.org/WhyReiser4IsNotIn
http://lkml.org/lkml/2006/7/28/180
http://www.gossamer-threads.com/lists/engine?do=post_view_flat;post=668645;page=1;sb=post_latest_reply;so=ASC;mh=25;list=linux

Now that Hans is out of the picture, and Namesys seems to have
collapsed, maybe someone can yank out the plugin architecture that
Linus and others have objected to, which as near as I could tell was
part of the Namesys's somewhat dodgy business plan of creating and
selling (possibly proprietary; not sure what license they were going
to be under) plugin modules for Reiser4 to make money.  The other
issue that was raised during the review were some locking issues
raised by Al Viro, if memory serves correctly.  I'm not sure if they
were ever fixed; at least initially they were brushed aside by Hans.  

In the meantime, people who really like reiser4 might want to take a
look at btrfs; it has a number of the same design ideas that reiser3/4
had --- except (a) the filesystem format has support for some advanced
features that are designed to leapfrog ZFS, (b) the maintainer is not
a crazy man and works well with other LKML developers (free hint: if
your code needs to be reviewed to get in, and reviewers are scarce;
don't insult and abuse the volunteer reviewers as Hans did --- Not a
good plan!).

						- Ted
