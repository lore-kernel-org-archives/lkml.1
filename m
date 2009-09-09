Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbZIIMna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbZIIMna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZIIMna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:43:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZIIMn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:43:29 -0400
Date: Wed, 9 Sep 2009 08:43:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090909124328.GA7747@infradead.org>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <20090909092901.GA24185@localhost> <20090909122805.GA30238@infradead.org> <20090909123223.GB23006@localhost> <20090909123746.GB18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909123746.GB18599@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 02:37:46PM +0200, Jens Axboe wrote:
> They are there, have been for months! But I think Christoph is a little
> confused, we'll still do writeback inline from balance_dirty_pages(). It
> does writeback_inodes_wbc(), which does not schedule async writeout.

Hmm, at least the version I have applied right now calls
bdi_start_writeback and not writeback_inodes_wbc from
balance_dirty_pages.  But you sent our another spin or two afer those,
so maybe it changed again.

