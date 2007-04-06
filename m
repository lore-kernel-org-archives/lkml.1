Return-Path: <linux-kernel-owner+w=401wt.eu-S1767540AbXDFHWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767540AbXDFHWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 03:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767536AbXDFHWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 03:22:23 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:39291 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767540AbXDFHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 03:22:22 -0400
Subject: Re: [PATCH 02/12] mm: scalable bdi statistics counters.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com
In-Reply-To: <20070405153746.3cdb9bcd.akpm@linux-foundation.org>
References: <20070405174209.498059336@programming.kicks-ass.net>
	 <20070405174317.854739299@programming.kicks-ass.net>
	 <20070405153746.3cdb9bcd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 09:22:19 +0200
Message-Id: <1175844139.6483.133.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 15:37 -0700, Andrew Morton wrote:
> On Thu, 05 Apr 2007 19:42:11 +0200
> root@programming.kicks-ass.net wrote:
> 
> > Provide scalable per backing_dev_info statistics counters modeled on the ZVC
> > code.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  block/ll_rw_blk.c           |    1 
> >  drivers/block/rd.c          |    2 
> >  drivers/char/mem.c          |    2 
> >  fs/char_dev.c               |    1 
> >  fs/fuse/inode.c             |    1 
> >  fs/nfs/client.c             |    1 
> >  include/linux/backing-dev.h |   98 +++++++++++++++++++++++++++++++++++++++++
> >  mm/backing-dev.c            |  103 ++++++++++++++++++++++++++++++++++++++++++++
> 
> madness!  Quite duplicative of vmstat.h, yet all this infrastructure
> is still only usable in one specific application.
> 
> Can we please look at generalising the vmstat.h stuff?
> 
> Or, the API in percpu_counter.h appears suitable to this application.
> (The comment at line 6 is a total lie).

Ok, I'll see what I can come up with.

