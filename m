Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497Ab0AJXRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0AJXRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441Ab0AJXRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:17:15 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:35083 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754393Ab0AJXRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:17:13 -0500
Date: Mon, 11 Jan 2010 10:17:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow linker to eliminate unused functions in lib/*
Message-ID: <20100110231708.GC4019@discord.disaster>
References: <20100105145917.GA25570@basil.fritz.box> <20100108162930.a011749a.akpm@linux-foundation.org> <20100109165155.GD20773@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100109165155.GD20773@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 05:51:56PM +0100, Andi Kleen wrote:
> > Sneaky.
> > 
> > It's a bit sad to reduce the code cleanliness and maintainability in
> > this way, but 1k is 1k.
> 
> Yes. I had actually hoped for more too. I think it might bring 
> more with -ffunction-sections/--gc-sections, but I haven't tried that.
> 
> An alternative might be also to give some more of those explicit Kconfig
> symbols -- then kernels with module loading enabled would benefit more
> too -- but I haven't investigated how many changes that would need.
> 
> But even with that it's a reasonable improvement and putting the exports
> separately is not too bad.
> 
> > The patch assumes a pre-existing lib-syms.c.  Confused.
> 
> Sorry, some day I'll learn how to operate quilt properly.
> 
> Updated patch with all files included appended.

Andi, how do you want to handle the overlap between this and the
list_sort() patch I sent? I'm going to need a list_sort() available
in the XFS tree well before the 2.6.34 merge window....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
