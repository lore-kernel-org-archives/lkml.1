Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYHXBGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYHXBGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 21:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYHXBGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 21:06:07 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38115 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751941AbYHXBGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 21:06:06 -0400
Date: Sat, 23 Aug 2008 21:05:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 bug fixes
Message-ID: <20080824010554.GE18169@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1KWXf5-0004gv-P7@closure.thunk.org> <20080823234439.GA24760@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080823234439.GA24760@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 07:44:39PM -0400, Christoph Hellwig wrote:
> >       ext4: Initialize writeback_index to 0 when allocating a new inode
> 
> Since commit 7d455e0030eeab820773e7786605be4d9e56a04b this is already
> done in common code, so this changeset doesn't have any effect.
> 

Hmm, I thought Andrew said he this was better to do in each filesystem
rather than in the common code, so I thought he was NACK'ing that
patch.  Still, I see his sign-off, so I guess I must have misread the
thread.....

						- Ted

