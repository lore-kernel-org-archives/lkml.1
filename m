Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZLUKvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZLUKvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 05:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZLUKvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 05:51:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57133 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbZLUKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 05:51:40 -0500
Date: Mon, 21 Dec 2009 11:51:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, rguenther@suse.de,
       arnd@arndb.de
Subject: Re: [PATCH] Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with
	gcc 4.5 snapshot
Message-ID: <20091221105138.GD25372@basil.fritz.box>
References: <20091220165315.GA13208@basil.fritz.box> <200912212102.39878.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912212102.39878.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 09:02:39PM +1030, Rusty Russell wrote:
> On Mon, 21 Dec 2009 03:23:15 am Andi Kleen wrote:
> > Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with gcc 4.5 snapshot
> > 
> > The BUILD_BUG_ON in compat_ioctl_check_table() fails
> > with a recent gcc mainline snapshot (gcc version 4.5.0 20091219)
> > (GCC)), even though it works with older compilers.
> 
> We have a proper fix for BUILD_BUG_ON which I sent Linus a pull req for,
> but I think it was too late:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git BUILD_BUG_ON
> 
> It's not really high priority, but it'd be nice to fix this properly.

AFAIK the code I fixed was not correct in the first place because
"const int xxx" is not a constant expression in the standards sense.

So it's orthogonal to whatever changes you come up.

Building on gcc 4.5 is at least medium priority I would say.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
