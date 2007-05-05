Return-Path: <linux-kernel-owner+w=401wt.eu-S1423143AbXEEBH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423143AbXEEBH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161615AbXEEBH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:07:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38526 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161609AbXEEBHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:07:55 -0400
Date: Fri, 4 May 2007 18:07:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 2/3] SLUB: Implement targeted reclaim and partial list
 defragmentation
In-Reply-To: <20070504180401.5d5fc6dd.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0705041807210.28556@schroedinger.engr.sgi.com>
References: <20070504221555.642061626@sgi.com> <20070504221708.596112123@sgi.com>
 <Pine.LNX.4.64.0705041603150.27790@schroedinger.engr.sgi.com>
 <20070504180401.5d5fc6dd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Randy Dunlap wrote:

> >  	/* Perform the KICK callbacks to remove the objects */
> >  	for(p = addr; p < addr + s->objects * s->size; p += s->size)
> 
> missed a space after "for".

Thanks but I was more hoping for a higher level of review. Locking????

