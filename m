Return-Path: <linux-kernel-owner+w=401wt.eu-S933930AbXGYRy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930AbXGYRy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbXGYRyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:54:19 -0400
Received: from holomorphy.com ([66.93.40.71]:50724 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbXGYRyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:54:19 -0400
Date: Wed, 25 Jul 2007 10:56:06 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070725175606.GP11781@holomorphy.com>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com> <20070717193308.GD25301@v2.random> <20070718133222.GM11781@holomorphy.com> <20070724194418.GH19559@v2.random> <20070725032011.GN6909@holomorphy.com> <20070725143904.GI19559@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725143904.GI19559@v2.random>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:39:04PM +0200, Andrea Arcangeli wrote:
> For the kernel stack btw, when alloc_pages(order=1) fails vmalloc
> should be used and 4k stacks can be dropped. Nobody does dma from the
> stack anymore these days IIRC (it doesn't work in all archs anyway).

I have recent code for that circulating, albeit intended for debugging
purposes. There's nothing particularly debug-oriented about it, though,
apart from the fact a guard page is automatically set up by vmalloc()
and that the use of vmalloc() is unconditional.

As for the rest, I'm sure there could be a lively conversation, but
consensus, so I'll let it go.


-- wli
