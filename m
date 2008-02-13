Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbYBMCJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbYBMCJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYBMCIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:08:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbYBMCIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:08:52 -0500
Date: Tue, 12 Feb 2008 18:06:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, bfields@fieldses.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-Id: <20080212180613.a1a07264.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802121743400.2920@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org>
	<20080212.165014.01238510.davem@davemloft.net>
	<alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org>
	<20080212.173817.111913348.davem@davemloft.net>
	<alpine.LFD.1.00.0802121743400.2920@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 17:57:19 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  - and you actually can help fix your issues by doing some simple things 
>    *before* pushing out, rather than push out immediately. IOW, do your 
>    whitespace sanity fixes, your compile checks etc early, and don't push 
>    out until after you've done them.
> 

One of the things which linux-next could/should do is to help weed out the
silly build breaks, typos, missing documentation updates, missed checkpatch
opportunities, etc, etc. As well as real bugs.

So it would not be efficient for David to do all this queue-cleaning
*prior* to putting the tree into linux-next, because more stuff will pop up
anyway.

So perhaps a better workflow would be keep the linux-next trees all messy,
and then each developer can consolidate, rebase, join and drop things prior
to sending their individual trees to Linus.

If so, then git could perhaps help, by retaining sufficient metadata for
the maintainer to track the fact that this-patch-here fixes
that-patch-there.

