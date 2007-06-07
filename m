Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbXFGHdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbXFGHdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXFGHc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:32:57 -0400
Received: from holomorphy.com ([66.93.40.71]:45086 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXFGHc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:32:57 -0400
Date: Thu, 7 Jun 2007 00:34:04 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070607073404.GU6909@holomorphy.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070607064231.GQ6909@holomorphy.com> <20070606235131.a56242cd.akpm@linux-foundation.org> <20070607065544.GR6909@holomorphy.com> <20070607000125.40ba8dc6.akpm@linux-foundation.org> <20070607070407.GS6909@holomorphy.com> <20070607070513.GT6909@holomorphy.com> <20070607001922.9f73902b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607001922.9f73902b.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 12:19:22AM -0700, Andrew Morton wrote:
> hm, OK, this seems to work:
[...]
> -#ifdef CONFIG_HIGHMEM
> +#if defined(CONFIG_HIGHMEM) && defined(CONFIG_ARCH_POPULATES_NODE_MAP)
>  	return movable_zone == ZONE_HIGHMEM;
>  #else
>  	return 0;
> _
> (the first ifdef is just there to trip things at compile time rather than
> link time)

I guess it's not the arch's fault after all. I probably would've
conditionally out-of-lined the thing so as never to expose movable_zone
but this will do just fine.


-- wli
