Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZEKRLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZEKRLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZEKRLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:11:35 -0400
Received: from thunk.org ([69.25.196.29]:59017 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZEKRLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:11:34 -0400
Date: Mon, 11 May 2009 13:10:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, sandeen@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] fiemap tester
Message-ID: <20090511171046.GA21518@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com, linux-kernel@vger.kernel.org
References: <20090508191649.GG9068@unused.rdu.redhat.com> <20090508161318.c73d766c.akpm@linux-foundation.org> <20090511094639.GA7488@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511094639.GA7488@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 05:46:39AM -0400, Christoph Hellwig wrote:
> 
> Last time I brought the idea of a small in-tree test harness up at KS
> people weren't too fond of it, but if we get more backing now we could
> try it, otherwise we can just stick it into xfsqa which will hopefully
> soon be generalized to a general fs QA suite.

Two questions --- first of all, has there been any progress with
respect to fixing the licensing of the xfsqa tree.  (i.e., "All Rights
Reserved" needs to change to a GPLv2 license)?  

And would you be open to cleaning up xfsqa by for example, moving some
of the tests out of the top-level directory, adding a modified xfs_io
to xfsqa (modified to not avoid using XFS-specific ioctl whereever
possible), etc.

I've been collecting my own set of test programs for ext4, and I've
thought about trying to use xfsqa, but it's not obvious to me it would
be more or less work, since in many ways there are a lot of places
where a lot of cleanup work and filesystem portability work would be
needed, and it's not clear that creating a new test framework and
collection of tests would be more or less work.

(For example, of cleanup that I'd love to see, I'd really like to use
real names for tests and not just random three digit numbers like 107,
108, 109, all cluterring the top-level directory along with 107.out,
108.out, 109.out, etc.)

Of course, until the copyright/licensing situation is cleared up, all
of these other issues are rather moot....

					- Ted
