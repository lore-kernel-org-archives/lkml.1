Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbXKHTQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbXKHTQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761119AbXKHTQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:16:35 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:33459 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761024AbXKHTQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:16:35 -0500
Date: Thu, 8 Nov 2007 11:16:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Mel Gorman <mel@skynet.ie>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/23] SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
In-Reply-To: <20071108172548.GW17536@waste.org>
Message-ID: <Pine.LNX.4.64.0711081116060.9279@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011226.844437184@sgi.com>
 <20071108145044.GB2591@skynet.ie> <20071108172548.GW17536@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Matt Mackall wrote:

> > I cannot figure out what the number of cycles currently showing on the TSC
> > have to do with a ratio :(. I could semi-understand if we were counting up
> > how many cycles were being spent trying to pack objects but that does not
> > appear to be the case. The comment didn't help a whole lot either. It felt
> > like a cost for packing, not a ratio
> 
> It's just a random number generator. And a bad one: lots of arches
> return 0. And I believe at least one of them has some NUMA support.

Do we have a better one? Something with minimal processing overhead? I'd 
be glad to switch it.

