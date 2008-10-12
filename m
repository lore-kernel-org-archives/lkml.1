Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbYJLHVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbYJLHVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 03:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYJLHVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 03:21:02 -0400
Received: from colo.lackof.org ([198.49.126.79]:34834 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYJLHVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 03:21:01 -0400
Date: Sun, 12 Oct 2008 01:20:49 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, grundler@parisc-linux.org,
       yinghai@kernel.org, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081012072049.GC20056@colo.lackof.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <20081010114002D.fujita.tomonori@lab.ntt.co.jp> <200810100848.09557.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810100848.09557.jbarnes@virtuousgeek.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 08:48:08AM -0700, Jesse Barnes wrote:
...
> Another option would be to add a 'warn_dma_mask=0xxxxxxxxx' boot option that 
> would trigger in the actual DMA mask setting routines.  It would let you 
> choose the mask you'd like to see warnings about.  Yinghai?

No, please don't. We have too many command line options already.

Dumping dma_mask and dma_consistent_mask from /sys is not hard.
I'd prefer Yinghai get credit for doing this since he's raised the issue
and took the time to submit a patch.

thanks,
grant
