Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab0CBXlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:41:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757724Ab0CBXl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:41:29 -0500
Date: Tue, 2 Mar 2010 15:40:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 2
In-Reply-To: <21d7e9971003021527t41268786q302a218ffe410763@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003021536280.3616@localhost.localdomain>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>  <alpine.LFD.2.00.1003021459450.3616@localhost.localdomain>  <alpine.DEB.2.00.1003022305070.4099@skynet.skynet.ie>
 <21d7e9971003021527t41268786q302a218ffe410763@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Dave Airlie wrote:
>
> Did I mention that driver is in STAGING?

Staging is for _improving_ the quality of the drivers, not for making it 
worse.

We still very much have quality standards. The staging tree is for things 
to get in that don't quite _reach_ the standards we expect, but it's not a 
blanket excuse for not testing things.

And yes, I expect that stuff can be a bit rough during the merge window, 
after all, the whole point is that we can fix things up. But quite 
frankly, if _I_ find problems on the few machines I personally build and 
test on, then what does that say about the bigger picture?

IOW, I refuse to pull code that doesn't even work for me. If I did, where 
would we end up? What do you think should be my minimal quality 
requirements, if "Oh, it doesn't even build for me" is too much to ask 
for?

So if I find code that doesn't work, I'm not going to just say "whatever". 
I'm going to reject it.

			Linus
