Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbXEJSJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbXEJSJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbXEJSJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:09:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54133 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752696AbXEJSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:09:30 -0400
Date: Thu, 10 May 2007 11:09:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] memory hotremove patch take 2 [05/10] (make basic remove
 code)
In-Reply-To: <20070509120512.B910.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0705101108251.10002@schroedinger.engr.sgi.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
 <20070509120512.B910.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Yasunori Goto wrote:

> +/*
> + * Just an easy implementation.
> + */
> +static struct page *
> +hotremove_migrate_alloc(struct page *page,
> +			unsigned long private,
> +			int **x)
> +{
> +	return alloc_page(GFP_HIGH_MOVABLE);
> +}

This would need to reflect the zone in which you are performing hot 
remove. Or is hot remove only possible in the higest zone?

