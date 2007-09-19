Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbXISRl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbXISRl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763603AbXISRkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:40:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36619 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763625AbXISRki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:40:38 -0400
Date: Wed, 19 Sep 2007 10:40:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Gabriel C <nix.or.die@googlemail.com>
cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [14/17] Allow bit_waitqueue to wait on a bit in a vmalloc area
In-Reply-To: <46F0A199.30706@googlemail.com>
Message-ID: <Pine.LNX.4.64.0709191040130.11527@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033643.537998421@sgi.com>
 <46F0A199.30706@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Gabriel C wrote:

> Christoph Lameter wrote:
> 
> >  
> > +	if (is_vmalloc_addr(word))
> > +		page = vmalloc_to_page(word)
> 					^^^^^^
> Missing ' ; '

Argh. Late beautification attempts are backfiring....
