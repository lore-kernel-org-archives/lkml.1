Return-Path: <linux-kernel-owner+w=401wt.eu-S1763008AbXIZVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763008AbXIZVOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXIZVOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:14:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57178
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbXIZVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:14:45 -0400
Date: Wed, 26 Sep 2007 14:14:44 -0700 (PDT)
Message-Id: <20070926.141444.77257648.davem@davemloft.net>
To: willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] dmapool: Improve memory usage for devices which
 can't cross boundaries
From: David Miller <davem@davemloft.net>
In-Reply-To: <11908332791548-git-send-email-willy@linux.intel.com>
References: <20070926185757.GM3899@parisc-linux.org>
	<11908332791548-git-send-email-willy@linux.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 26 Sep 2007 15:01:19 -0400

> The previous implementation simply refused to allocate more than a
> boundary's worth of data from an entire page.  Some users didn't know
> this, so specified things like SMP_CACHE_BYTES, not realising the
> horrible waste of memory that this was.  It's fairly easy to correct
> this problem, just by ensuring we don't cross a boundary within a page.
> This even helps drivers like EHCI (which can't cross a 4k boundary)
> on machines with larger page sizes.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

This one looks good to me:

Acked-by: David S. Miller <davem@davemloft.net>
