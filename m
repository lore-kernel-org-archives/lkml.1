Return-Path: <linux-kernel-owner+w=401wt.eu-S1765752AbXGKRtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765752AbXGKRtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXGKRtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:49:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39169 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765491AbXGKRtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:49:42 -0400
Date: Wed, 11 Jul 2007 10:49:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
In-Reply-To: <20070711094229.GC7568@skynet.ie>
Message-ID: <Pine.LNX.4.64.0707111047040.14201@schroedinger.engr.sgi.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707101303450.22199@schroedinger.engr.sgi.com>
 <20070711094229.GC7568@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Mel Gorman wrote:

> I would like the patches to go through on the grounds that higher order
> allocations can succeed. However, I am also happy to say that order-0
> pages should be used as much as possible, that case should always be
> made as fast as possible and the world must not end if a high-order
> allocation fails.

SLUB can easily be made to not use higher order pages.

If the SLUB mobility patches are not merged then higher order page use 
can be explicitly enabled via passing the following to the kernel on boot

	slub_max_order=<desired max order>

If they are merged then the higher order page use can be disabled in case 
of trouble via

	slub_max_order=0
