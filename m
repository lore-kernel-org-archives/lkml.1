Return-Path: <linux-kernel-owner+w=401wt.eu-S933380AbXBXEYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbXBXEYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 23:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933381AbXBXEYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 23:24:51 -0500
Received: from holomorphy.com ([66.93.40.71]:39364 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933380AbXBXEYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 23:24:51 -0500
Date: Fri, 23 Feb 2007 20:24:44 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070224042444.GU21484@holomorphy.com>
References: <20070223153743.GA26141@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223153743.GA26141@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 04:37:43PM +0100, Nick Piggin wrote:
> The dentry hash uses up 8MB for 1 million entries on my 4GB system is
> one of the biggest wasters of memory for me. Because I rarely have
> more than one or two hundred thousand dentries. And that's with
> several kernel trees worth of entries. Most desktop and probably even
> many types of servers will only use a fraction of that.
> So I introduce a new method for resizing hash tables with RCU, and apply
> that to the dentry hash.
> The primitive heuristic is that the hash size is doubled when the number of
> entries reaches 150% the hash size, and halved when the number is 50%.
> It should also be able to shrink under memory pressure, and scale up as
> large as we go.

You would be better served by a data structure different from a hashtable.


-- wli
