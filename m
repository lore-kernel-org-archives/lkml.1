Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbXKGI5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbXKGI5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbXKGI5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:57:07 -0500
Received: from saeurebad.de ([85.214.36.134]:41640 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbXKGI5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:57:06 -0500
Date: Wed, 7 Nov 2007 09:55:45 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 07/23] SLUB: Add defrag_ratio field and sysfs support.
Message-ID: <20071107085545.GB6243@cataract>
Mail-Followup-To: Christoph Lameter <clameter@sgi.com>,
	akpm@linux-foundatin.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>
References: <20071107011130.382244340@sgi.com> <20071107011228.102370371@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107011228.102370371@sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Tue, Nov 06, 2007 at 05:11:37PM -0800, Christoph Lameter wrote:
> --- linux-2.6.orig/include/linux/slub_def.h	2007-11-06 12:36:28.000000000 -0800
> +++ linux-2.6/include/linux/slub_def.h	2007-11-06 12:37:44.000000000 -0800
> @@ -53,6 +53,13 @@ struct kmem_cache {
>  	void (*ctor)(struct kmem_cache *, void *);
>  	int inuse;		/* Offset to metadata */
>  	int align;		/* Alignment */
> +	int defrag_ratio;	/*
> +				 * objects/possible-objects limit. If we have
> +				 * less that the specified percentage of

That should be `less than', I guess.

	Hannes
