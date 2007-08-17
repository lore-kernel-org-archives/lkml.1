Return-Path: <linux-kernel-owner+w=401wt.eu-S1765681AbXHQQYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765681AbXHQQYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXHQQYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:24:00 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48093 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbXHQQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:23:59 -0400
Date: Fri, 17 Aug 2007 12:23:04 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH 17/23] mm: count reclaimable pages per BDI
Message-ID: <20070817162304.GB27836@filer.fsl.cs.sunysb.edu>
References: <20070816074525.065850000@chello.nl> <20070816074628.776394000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816074628.776394000@chello.nl>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:45:42AM +0200, Peter Zijlstra wrote:
...
> Index: linux-2.6/include/linux/backing-dev.h
> ===================================================================
> --- linux-2.6.orig/include/linux/backing-dev.h
> +++ linux-2.6/include/linux/backing-dev.h
> @@ -27,6 +27,7 @@ enum bdi_state {
>  typedef int (congested_fn)(void *, int);
>  
>  enum bdi_stat_item {
> +	BDI_RECLAIMABLE,
>  	NR_BDI_STAT_ITEMS
>  };

Ok, I see. Ignore my comment on 16/xx :)

Jeff.

-- 
Keyboard not found!
Press F1 to enter Setup
