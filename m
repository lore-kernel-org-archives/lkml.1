Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbXHITPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbXHITPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXHITPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:15:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36597 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756025AbXHITPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:15:09 -0400
Date: Thu, 9 Aug 2007 12:15:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH 17/23] mm: count writeback pages per BDI
In-Reply-To: <20070803125237.072937000@chello.nl>
Message-ID: <Pine.LNX.4.64.0708091214330.27092@schroedinger.engr.sgi.com>
References: <20070803123712.987126000@chello.nl> <20070803125237.072937000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Peter Zijlstra wrote:

>  						page_index(page),
>  						PAGECACHE_TAG_WRITEBACK);
> +			if (bdi_cap_writeback_dirty(bdi))
> +				__dec_bdi_stat(bdi, BDI_WRITEBACK);

Why are these not incremented and decremented in the exact location of 
NR_WRITEBACK?
