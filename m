Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZDFScV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZDFScV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZDFScK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:32:10 -0400
Received: from thunk.org ([69.25.196.29]:35057 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbZDFScJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:32:09 -0400
Date: Mon, 6 Apr 2009 14:31:57 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090406183157.GD7376@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 08:45:09AM -0700, Linus Torvalds wrote:
> 
> With that request size limiting, my fsync pauses tend to be in the 250ms 
> range, with a one 0.75s outlier in the last few minutes. I can definitely 
> feel that quarter-second thing, and the .75s pause was a real stutter, but 
> boy what a difference. I don't get the uncontrollable urge to kill that 
> nasty background writer any more.

Cool!  Maybe we can make things even better, but given where we are
at, this brings up an question: given Jens block latency patches
(thanks, Jens!), and the patches which add the flush on
replace-via-rename/replace-via-truncate for ext3 data=writeback,
should we make ext3 data=writeback the default for 2.6.30?

					- Ted
