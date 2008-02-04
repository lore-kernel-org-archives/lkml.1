Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYBDRvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYBDRvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYBDRvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:51:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:26361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbYBDRvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:51:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,303,1199692800"; 
   d="scan'208";a="295670994"
Date: Mon, 4 Feb 2008 09:55:26 -0800
From: mark gross <mgross@linux.intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Pull request: DMA pool updates
Message-ID: <20080204175526.GA21144@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080129001147.GD31101@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129001147.GD31101@parisc-linux.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 05:11:47PM -0700, Matthew Wilcox wrote:
> G'day Linus, mate
> 
> Could you pull the dmapool branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git please?
> 
> All the patches have been posted to linux-kernel before, and various
> comments (and acks) have been taken into account.
> 
> It's a fairly nice performance improvement, so would be good to get in.
> It's survived a few hours of *mumble* high-stress database benchmark,
> so I have high confidence in its stability.

I haven't looked at this yet but, I've been doing some work with the
IOMMU performance impacts on DMA operations.  DMApooling  could provide
a way to mitigate some of the spankage gotten when using IOMMU's.

--mgross

> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
