Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZAKANS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZAKANS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZAKANH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:13:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbZAKANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:13:05 -0500
Date: Sat, 10 Jan 2009 16:13:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.29-rc1
Message-ID: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The merge window is over, and while it is quite possible that I missed a 
few merge requests in the crazy week that is behind us, apart from those 
we should now have most of the bulk of 2.6.29 merged up. And now it's just 
a small matter of making sure it's all stable and ready to go.

I wanted to release -rc1 with time enough that by the time I'm on my way 
to LCA next weekend, we'd have an -rc2 too, and the worst fallout from 
-rc1 would be fixed.

But I know all you nice developers have been oh-so-careful, and there 
won't be any fall-out, will there? I'm sure -rc1 is going to be fine. 
Chortle.

In pure absolute bulk, almost exactly half of the -rc1 merge was all 
just staging drivers, notably a few new wireless drivers that really 
aren't ready for real consumption, but that under the new staging rules 
are being let in early to hopefully be cleaned up. 

Of the remaining 50%, 40% is just regular driver updates: networking (lots 
of wireless), usb, DVB, DRM you name it. Pretty standard stuff.

But what perhaps stands out more is that we merged two whole new 
filesystems - both btrfs and squashfs got merged. Even if they look pretty 
"small" in that relentless onslaught of drivers.

Other than that? Changes everywhere. Arch updates, VM and core kernel 
stuff, you name it, it got updated. As usual, even the shortlog is _way_ 
too big to post here, at about ten thousand lines and half a meg. Just 
take my word for it, or download the whole thing.

More productive tends to be looking at a specific area, and just asking 
git about it. While the whole thing is pretty daunting, doing something 
like

	git shortlog --no-merges v2.6.28.. drivers/net/wireless

(pick your particular area of interest yourself, of course) can be 
informative.

Anyway, give it a good testing. And please do keep in mind that while new 
filesystems can be intruiging and exciting, "new" also means "not widely 
tested". I'm sure the btrfs people will appreciate people testing, but I 
would suggest that you go very very carefully (squashfs is read-only, so 
it's presumably less likely to eat your data, but who knows - the 
perversity of the universe is endless).

				Linus
