Return-Path: <linux-kernel-owner+w=401wt.eu-S933706AbZJIPsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbZJIPsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933613AbZJIPsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:48:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518AbZJIPsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:48:37 -0400
Date: Fri, 9 Oct 2009 17:47:59 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
	balance_dirty_pages()
Message-ID: <20091009154759.GJ7654@duck.suse.cz>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz> <1255101512.8802.65.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255101512.8802.65.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 09-10-09 17:18:32, Peter Zijlstra wrote:
> On Fri, 2009-10-09 at 17:12 +0200, Jan Kara wrote:
> >   Ugh, but this is not equivalent! We would block the writer on some BDI
> > without any dirty data if we are over global dirty limit. That didn't
> > happen before.
> 
> It should have, we should throttle everything calling
> balance_dirty_pages() when we're over the total limit.
  OK :) I agree it's reasonable. But Wu, please note this in the
changelog because it might be a substantial change for some loads.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
