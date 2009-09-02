Return-Path: <linux-kernel-owner+w=401wt.eu-S1751888AbZIBHf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbZIBHf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 03:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbZIBHf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 03:35:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZIBHf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 03:35:28 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_pages
From: Peter Zijlstra <peterz@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
In-Reply-To: <1251876776.7547.52.camel@twins>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
	 <1251803946-9243-9-git-send-email-jens.axboe@oracle.com>
	 <1251830335.8502.17.camel@laptop> <20090901184455.GA27294@infradead.org>
	 <20090901202747.GC6996@mit.edu>  <1251876776.7547.52.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Sep 2009 09:35:08 +0200
Message-Id: <1251876908.7547.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, 2009-09-01 at 16:27 -0400, Theodore Tso wrote:

> > So perhaps the best argument for not making this be a tunable is that
> > in the long run, we will need to put in a better algorithm for
> > controlling how much writeback we want to do before we start
> > saturating RAID arrays, and in that new algorithm this tunable may no
> > longer make sense.  Fine; at that point, we can make it go away.  For
> > now, though, it seems to be the best way to tweak what is going on,
> > since I doubt we'll be able to come up with one magic number that will
> > satisfy everyone.

Also, what is the incentive to actually improve the situation once we
merge this? People will say, turn the knob and don't bother us.
