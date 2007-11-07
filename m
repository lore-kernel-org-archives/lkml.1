Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXKGSaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXKGSaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXKGSaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:30:13 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53128 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753262AbXKGSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:30:11 -0500
Date: Wed, 7 Nov 2007 10:30:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Johannes Weiner <hannes-kernel@saeurebad.de>
cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 07/23] SLUB: Add defrag_ratio field and sysfs support.
In-Reply-To: <20071107085545.GB6243@cataract>
Message-ID: <Pine.LNX.4.64.0711071030040.9857@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011228.102370371@sgi.com>
 <20071107085545.GB6243@cataract>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Johannes Weiner wrote:

> Hi Christoph,
> 
> On Tue, Nov 06, 2007 at 05:11:37PM -0800, Christoph Lameter wrote:
> > --- linux-2.6.orig/include/linux/slub_def.h	2007-11-06 12:36:28.000000000 -0800
> > +++ linux-2.6/include/linux/slub_def.h	2007-11-06 12:37:44.000000000 -0800
> > @@ -53,6 +53,13 @@ struct kmem_cache {
> >  	void (*ctor)(struct kmem_cache *, void *);
> >  	int inuse;		/* Offset to metadata */
> >  	int align;		/* Alignment */
> > +	int defrag_ratio;	/*
> > +				 * objects/possible-objects limit. If we have
> > +				 * less that the specified percentage of
> 
> That should be `less than', I guess.

Correct.

