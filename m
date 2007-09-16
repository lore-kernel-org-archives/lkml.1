Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbXIPKer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbXIPKer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 06:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXIPKej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 06:34:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbXIPKei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 06:34:38 -0400
Date: Sun, 16 Sep 2007 03:34:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/13] Reduce external fragmentation by grouping pages by
 mobility v30
Message-Id: <20070916033426.5097a5b0.akpm@linux-foundation.org>
In-Reply-To: <20070914143355.GD30407@skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
	<20070913180156.ee0cdec4.akpm@linux-foundation.org>
	<20070914143355.GD30407@skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 15:33:55 +0100 mel@skynet.ie (Mel Gorman) wrote:

> Go ahead with the patches you already
> have if you prefer. Just make sure not to include
> breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
> as it's only required for page-owner-tracking.

memory-unplug-v7-page-isolation.patch uses page_order() also, so I brought this patch back.
