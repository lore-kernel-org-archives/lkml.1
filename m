Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbYBMPbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbYBMPbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYBMPbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:31:47 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4682 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbYBMPbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:31:46 -0500
Date: Wed, 13 Feb 2008 10:06:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, bfields@fieldses.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213150616.GB31839@tuxdriver.com>
References: <20080212.173817.111913348.davem@davemloft.net> <alpine.LFD.1.00.0802121743400.2920@woody.linux-foundation.org> <20080212180613.a1a07264.akpm@linux-foundation.org> <20080212.182012.153642549.davem@davemloft.net> <20080213024730.GA8798@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213024730.GA8798@mail.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 06:47:30PM -0800, Joel Becker wrote:

> 	Make the distinction earlier.  With ocfs2 and configfs (we got
> this scheme from Jeff), we keep the topic branches as "unsafe" - that
> is, officially rebaseable .  We merge them all into a big "ALL" branch,
> which is also "unsafe".  Andrew pulls this for -mm, and it gets tested 
> here.  If there is a brown-paper-bag problem, we can tell the original
> author to fix it.  Then we re-pull the topic - effectively a rebase.
> The ALL is also rebased.  But that's Ok, it will never go towards Linus.
> 	When a topic is considered worthy of going upstream, we pull it
> to a branch called "upstream-linus".  This branch is *NEVER* rebased.
> Now that the topic is in upstream-linus, the original topic branch can't
> be rebased either.  So any fixes to that topic going forward will stay
> in the history.  Since that topic was pulled into ALL for testing, we
> are using the identical commits that got tested.

This is essentially the same process I've been using in wireless-2.6
with the (regularly rebased) 'everything' branch.  Still I find
that it causes lots of confusion and complaining.  Perhaps I am not
communicating clearly enough... :-)

Do you find that people are happy with that process?  Forgive me for
not knowing, but how many developers are actively (or occasionaly)
involved in ocfs2 and configfs?  How many 'normal' users pull your
tree looking for 'latest and greatest' code?

John
-- 
John W. Linville
linville@tuxdriver.com
