Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZLKUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZLKUbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZLKUbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:31:38 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:50930 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZLKUbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:31:37 -0500
Date: Fri, 11 Dec 2009 12:29:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jan Kara <jack@suse.cz>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: Fix missing kernel-doc notation
Message-Id: <20091211122922.2b9e165c.randy.dunlap@oracle.com>
In-Reply-To: <20091122123347.GA19022@localhost>
References: <1258877769.4495.48.camel@ht.satnam>
	<20091122123347.GA19022@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B22ABFC.00B9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 20:33:47 +0800 Wu Fengguang wrote:

> 
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Thanks!

applied, thanks.


> On Sun, Nov 22, 2009 at 04:16:09PM +0800, Jaswinder Singh Rajput wrote:
> > 
> > Fix the following htmldocs warning:
> > 
> >   Warning(fs/fs-writeback.c:255): No description found for parameter 'sb'
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Cc: Wu Fengguang <fengguang.wu@intel.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  fs/fs-writeback.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 9d5360c..b15c97f 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -242,6 +242,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
> >  /**
> >   * bdi_start_writeback - start writeback
> >   * @bdi: the backing device to write from
> > + * @sb: write inodes from this super_block
> >   * @nr_pages: the number of pages to write
> >   *
> >   * Description:
> > -- 


---
~Randy
