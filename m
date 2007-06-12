Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbXFLMw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbXFLMw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbXFLMwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:52:15 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:50388 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbXFLMwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:52:14 -0400
Date: Tue, 12 Jun 2007 13:52:12 +0100
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make cmdline_parse_kernelcore() static
Message-ID: <20070612125212.GB26113@skynet.ie>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070612110742.GV3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070612110742.GV3588@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/06/07 13:07), Adrian Bunk didst pronounce:
> cmdline_parse_kernelcore() can become static.
> 

Agreed. I would consider this a fix to handle-kernelcore=-generic.patch

Thanks Adrian

Acked-by: Mel Gorman <mel@csn.ul.ie> 

> ---
> --- linux-2.6.22-rc4-mm2/mm/page_alloc.c.old	2007-06-12 02:10:56.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/mm/page_alloc.c	2007-06-12 02:11:08.000000000 +0200
> @@ -3879,7 +3879,7 @@
>   * kernelcore=size sets the amount of memory for use for allocations that
>   * cannot be reclaimed or migrated.
>   */
> -int __init cmdline_parse_kernelcore(char *p)
> +static int __init cmdline_parse_kernelcore(char *p)
>  {
>  	unsigned long long coremem;
>  	if (!p)

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
