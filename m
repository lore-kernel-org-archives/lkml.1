Return-Path: <linux-kernel-owner+w=401wt.eu-S1030371AbXBTTAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371AbXBTTAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030424AbXBTTAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:00:11 -0500
Received: from holomorphy.com ([66.93.40.71]:42959 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030371AbXBTTAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:00:09 -0500
Date: Tue, 20 Feb 2007 11:00:05 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] free swap space when (re)activating page
Message-ID: <20070220190005.GQ21484@holomorphy.com>
References: <45D63445.5070005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D63445.5070005@redhat.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 05:46:29PM -0500, Rik van Riel wrote:
> The attached patch does what I described in the other thread, it
> makes the pageout code free swap space when swap is getting full,
> by taking away the swap space from pages that get moved onto or
> back onto the active list.
> In some tests on a system with 2GB RAM and 1GB swap, it kept the
> free swap at 500MB for a 2.3GB qsbench, while without the patch
> over 950MB of swap was in use all of the time.
> This should give kswapd more flexibility in what to swap out.
> What do you think?
> Signed-off-by: Rik van Riel <riel@redhat.com>

I would call this a bugfix, not an optimization.


-- wli
