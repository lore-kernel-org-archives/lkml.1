Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbXCOLxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbXCOLxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 07:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933510AbXCOLxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 07:53:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15884 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbXCOLxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 07:53:47 -0400
Date: Thu, 15 Mar 2007 12:52:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch 1/2] splice: dont steal
Message-ID: <20070315115237.GM15400@kernel.dk>
References: <20070314121440.GA926@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314121440.GA926@wotan.suse.de>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14 2007, Nick Piggin wrote:
> Here are a couple of splice patches I found when digging in the area.
> I could be wrong, so I'd appreciate confirmation.
> 
> Untested other than compile, because I don't have a good splice test
> setup.
> 
> Considering these are data corruption / information leak issues, then
> we could do worse than to merge them in 2.6.21 and earlier stable
> trees.
> 
> Does anyone really use splice stealing?

That's a damn shame, I'd greatly prefer if we can try and fix it
instead. Splice isn't really all that used yet to my knowledge, but
stealing is one of the niftier features I think. Otherwise you're just
copying data again.

-- 
Jens Axboe

