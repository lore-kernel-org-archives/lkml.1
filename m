Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbXJYCPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbXJYCPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXJYCPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:15:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753202AbXJYCPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:15:35 -0400
Date: Wed, 24 Oct 2007 19:15:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Mel Gorman <mel@skynet.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
In-Reply-To: <20071024192849.GA3206@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0710241913220.29434@schroedinger.engr.sgi.com>
References: <20071023181615.GA10377@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
 <471E5021.8090300@cs.helsinki.fi> <Pine.LNX.4.64.0710231250130.19904@schroedinger.engr.sgi.com>
 <20071024080937.GA10785@skynet.ie> <20071024192849.GA3206@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Alexey Dobriyan wrote:

> [12728.701398] DMA free:8032kB min:32kB low:40kB high:48kB active:2716kB 
> inactive:2208kB present:12744kB pages_scanned:9299 all_unreclaimable? 
> yes [12728.701567] lowmem_reserve[]: 0 2003 2003 2003 [12728.701654] 

Ummm... all unreclaimable is set! Are you mlocking the pages in memory? Or 
what causes this? All pages under writeback? What is the dirty ratio set 
to?

> pages_scanned:9363 all_unreclaimable? yes [12735.178618] 

And again.

> lowmem_reserve[]: 0 2003 2003 2003 [12735.178706] DMA32 free:5700kB 
> min:5708kB low:7132kB high:8560kB active:512264kB inactive:1304912kB 
> present:2051880kB pages_scanned:3251584 all_unreclaimable? yes 

And again.

