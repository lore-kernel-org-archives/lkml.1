Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbZEAOa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbZEAOa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbZEAOaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:30:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44106 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbZEAOaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:30:01 -0400
Date: Fri, 1 May 2009 15:29:58 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
       davem@davemloft.net, anton@samba.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2.6.30] Doc: hashdist defaults on for 64bit
Message-ID: <20090501142957.GC27831@csn.ul.ie>
References: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils> <20090429142825.6dcf233d.akpm@linux-foundation.org> <Pine.LNX.4.64.0905011354560.19012@blonde.anvils> <Pine.LNX.4.64.0905011442540.19247@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905011442540.19247@blonde.anvils>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 02:45:43PM +0100, Hugh Dickins wrote:
> Update Doc: kernel boot parameter hashdist now defaults on for all 64bit NUMA.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
> 
>  Documentation/kernel-parameters.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 2.6.30-rc4/Documentation/kernel-parameters.txt	2009-04-30 06:39:30.000000000 +0100
> +++ linux/Documentation/kernel-parameters.txt	2009-05-01 14:08:56.000000000 +0100
> @@ -775,7 +775,7 @@ and is between 256 and 4096 characters.
>  
>  	hashdist=	[KNL,NUMA] Large hashes allocated during boot
>  			are distributed across NUMA nodes.  Defaults on
> -			for IA-64, off otherwise.
> +			for 64bit NUMA, off otherwise.
>  			Format: 0 | 1 (for off | on)
>  
>  	hcl=		[IA-64] SGI's Hardware Graph compatibility layer
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
