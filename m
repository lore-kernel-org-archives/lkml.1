Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0CDTIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:08:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672Ab0CDTIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:08:17 -0500
Date: Thu, 4 Mar 2010 11:08:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100304105624.70fe845e@jbarnes-piketon>
Message-ID: <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <20100304103655.0b14343f@jbarnes-piketon> <20100304103929.6eb81d45@jbarnes-piketon> <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
 <20100304105624.70fe845e@jbarnes-piketon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Jesse Barnes wrote:
> 
> If marking the driver as staging doesn't allow them to break ABI when
> they need to, then it seems like they'll have no choice but to either
> remove the driver from upstream and only submit it when the ABI is
> stable, or fork the driver and submit a new one only when the ABI is
> stable.  Neither seem particularly attractive.

The thing is, they clearly didn't even _try_ to make anything compatible. 
See how all the ioctl numbers were moved around. 

And if you can't make if backwards compatible, at least you should make it 
forwards-compatible. Is it even that? I don't know. I'm kind of afraid it 
isn't. The new libdrm required for it certainly hasn't been pushed to 
Fedora-12. Will it ever be? And if it is, can you still run an old kernel 
on it?

All of these are always possible to do. We've been _very_ good at doing 
them in general. I'm complaining, because let's face it, what else can I 
do?

And btw, I'd complain about breaking backwards compatibility even if it 
wasn't just my own machine. I can pretty much guarantee that I'm not going 
to be the only one hitting this issue.

So practically speaking: what _do_ you suggest we do about all the 
regressions this will cause?

			Linus
