Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbXIACHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbXIACHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 22:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXIACHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 22:07:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48183 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751178AbXIACHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 22:07:40 -0400
Date: Fri, 31 Aug 2007 19:07:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: apw@shadowen.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hch@lst.de, mel@skynet.ie, dgc@sgi.com
Subject: Re: [RFC 14/26] SLUB: __GFP_MOVABLE and SLAB_TEMPORARY support
In-Reply-To: <20070901110410.acea7b2b.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0708311906280.23843@schroedinger.engr.sgi.com>
References: <20070901014107.719506437@sgi.com> <20070901014222.536517408@sgi.com>
 <20070901110410.acea7b2b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007, KAMEZAWA Hiroyuki wrote:

> On Fri, 31 Aug 2007 18:41:21 -0700
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > +#ifndef CONFIG_HIGHMEM
> > +	if (s->kick || s->flags & SLAB_TEMPORARY)
> > +		flags |= __GFP_MOVABLE;
> > +#endif
> > +
> 
> Should I do this as
> 
> #if !defined(CONFIG_HIGHMEM) && !defined(CONFIG_MEMORY_HOTREMOVE)

Hmmm.... Not sure... I think the use of __GFP_MOVABLE the way it is up 
there will change as soon as Mel's antifrag patchset is merged.

