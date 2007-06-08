Return-Path: <linux-kernel-owner+w=401wt.eu-S969764AbXFHPgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969764AbXFHPgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764291AbXFHPgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:36:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40933 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967230AbXFHPgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:36:36 -0400
Date: Fri, 8 Jun 2007 08:36:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: alexn@telia.com, akpm@linux-foundation.org,
       Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow PAGE_OWNER to be set on any architecture
In-Reply-To: <20070608125349.GA8444@skynet.ie>
Message-ID: <Pine.LNX.4.64.0706080833560.32416@schroedinger.engr.sgi.com>
References: <20070608125349.GA8444@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Mel Gorman wrote:

> In situations where CONFIG_HOLES_IN_ZONES is set (IA64 with VIRTUAL_MEM_MAP),
> there may be cases where pages allocated within a MAX_ORDER_NR_PAGES block
> of pages may not be displayed in /proc/page_owner if the hole is at the
> start of the block. Addressing this would be quite complex, perform slowly
> and is of no clear benefit.

Note that CONFIG_HOLES_IN_ZONES and IA64 VIRTUAL_MEM_MAP may be going 
away. Andy Whitcroft has a patchset that implements virtual memmap 
support under sparse and that would allow us to get rid of this.



