Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbZIIMcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbZIIMcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZIIMce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:32:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:32543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZIIMcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:32:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185674625"
Date: Wed, 9 Sep 2009 20:32:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090909123223.GB23006@localhost>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <20090909092901.GA24185@localhost> <20090909122805.GA30238@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909122805.GA30238@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 08:28:06PM +0800, Christoph Hellwig wrote:
> On Wed, Sep 09, 2009 at 05:29:01PM +0800, Wu Fengguang wrote:
> > It seems that balance_dirty_pages() is not coupled with MAX_WRITEBACK_PAGES. 
> > Instead it uses the much smaller (ratelimit_pages + ratelimit_pages / 2).
> 
> With Jen's writeback patches applied balance_dirty_pages does not start
> writeback itself anymore but calls bdi_start_writeback to let the
> flusher thread do it.
> 
> it would be good if we do any writeback tuning ontop of these patches..

Ah OK. I'm using latest linux-next and expected his patches to be there..

Thanks,
Fengguang

