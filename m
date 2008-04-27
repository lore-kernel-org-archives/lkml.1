Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYD0G0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYD0G0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 02:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYD0G0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 02:26:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYD0G0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 02:26:06 -0400
Date: Sun, 27 Apr 2008 02:26:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080427062600.GA4392@infradead.org>
References: <20080426.215513.141243565.davem@davemloft.net> <20080427055943.GA16290@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427055943.GA16290@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 07:59:43AM +0200, Ingo Molnar wrote:
> here, two months ago:
> 
>   http://lkml.org/lkml/2008/3/3/122
> 
> i made it x86-only due to this FUD that went against it:
> 
>   "messing with a global #define in a way that the results on 24 
>    architectures with 7 different releases of gcc would be 
>    unpredictable."
> 
> ... as i saw no reason why this feature, which i found rather useful, 
> should be delayed another year or so. I'd be more than happy to promote 
> this feature back to lib/Kconfig.debug, sparc64 interest would make that 
> a strong argument.
> 
> and here is the pull request that i posted to lkml, with the full patch 
> included as well:
> 
>   http://www.gossamer-threads.com/lists/linux/kernel/911104?page=last

This still does not explain why it's two commits.   It also doesn't
explain the horrible cpp and ifdef abuse in there - having a config
symbol in one architecture only and then a cpp symbol to prevent the ill
effects of it in one signle architecture is simply utterly braindead,
sorry.

This kind of thing should be discussed at least on linux-arch and input
from at least partially wise people would have led too a much better
solution.  Like, umm moving the option to a global config file and let
the architecture default it to y/n where needed.

