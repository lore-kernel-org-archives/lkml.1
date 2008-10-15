Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYJOXIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYJOXIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYJOXIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:08:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41511
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbYJOXIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:08:44 -0400
Date: Wed, 15 Oct 2008 16:08:21 -0700 (PDT)
Message-Id: <20081015.160821.143702739.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, greg@kroah.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: is the weeks before -rc1 the time to really be working on
 -next?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081015155353.f15a996e.akpm@linux-foundation.org>
References: <20081015145606.2af3baf1.akpm@linux-foundation.org>
	<20081015233607.54c1d6b8@lxorguk.ukuu.org.uk>
	<20081015155353.f15a996e.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 15 Oct 2008 15:53:53 -0700

> But the problem here is that once linux-next merges your patches, you
> no longer have a tree on which to base your patches!  You need to get
> your hands on "linux-next without my stuff" to maintain them.

I know this doesn't work for you, but if you ran -mm just like any
other GIT tree it might mesh a whole lot better.

And in reality that kind of situation isn't a big deal in the
context of -next.  People are rebasing their trees all the time
there, and it mostly seems to work itself out.

It's a lot more work for a contributor to do work against -mm,
since the response to "which -mm should I work against and where
do I get it from" is a bit more involved that just "pull from
this GIT tree and do your work on top of that."

And just like networking we could have Stephen treat the -mm
GIT tree as "important" which roughly means that other conflicting
trees will be knocked out of a -next release in deference to -mm.

Those people will have to fix their stuff, not you.  And you'll
always therefore get coverage in -next.

Unlike the general sentiment expressed here, I think -next is helping.
Even if only because Stephen pokes people with trees causing problems
on a daily basis.
