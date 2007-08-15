Return-Path: <linux-kernel-owner+w=401wt.eu-S936538AbXHOVE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936538AbXHOVE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936158AbXHOVEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:04:04 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:53491 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936048AbXHOVEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:04:01 -0400
Date: Wed, 15 Aug 2007 17:04:00 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070815210400.GC9412@csclub.uwaterloo.ca>
References: <7B9C0CB2-7CE6-49E4-8F28-BBA96B1821B6@mac.com> <126267.7876.qm@web52506.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <126267.7876.qm@web52506.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 01:44:50PM -0700, Marc Perkel wrote:
> Yes - that's a good example. Git is far more powerful
> and a different paradigm for CVS. Someone had to think
> outside the box and come up with a new way of looking
> at things. I'm trying to do something like that with
> this idea.
> 
> To me it make more sense to get rid of file
> permissions and look at people permissions. It reminds
> me of a story a friend of mine told about her 4 year
> old son.
> 
> The story was that they were driving down the road
> when they saw a wheel come off a truck. The son said,
> "look mommy, that wheel lost it's truck."
> 
> To me files are like the wheel. Rather than having the
> file know all it's owners it makes more sense for the
> owners to know it's files.

Except for the fact that on most systems each owner may have millions of
files, while very rarely does a file have more than a few dozen owners
or groups.  Having to wade through the permissions of millions of things
seems like a lot more work than checking a few dozen things.

Also the thing is that I care who can access files, while I do not
really care what particular set of files a user has access to.  It is
the data I am protecting, not the user.

--
Len Sorensen
