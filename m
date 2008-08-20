Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYHTASz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYHTASz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYHTASr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:18:47 -0400
Received: from tau.jukie.net ([216.239.93.128]:44159 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYHTASr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:18:47 -0400
Date: Tue, 19 Aug 2008 20:18:45 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
Message-ID: <20080820001845.GC28029@jukie.net>
References: <20080819220311.GA28029@jukie.net> <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [080819 18:19]:
> And I think you hit this issue because you probably mounted the USB stick 
> as a "sync" (or dirsync) mount - which is what some distros do by default, 
> even if it is known to cause problems for some flash cards that don't do a 
> good job at wear levelling.

Hmm... I was considering the costs and benefits of sync mounts.  I don't
care about the performance hit, as I don't move that much data around.
Primarily, I like the fact that I can pull the media out w/o any special
action (which sometimes requires that I unlock my screensaver first).
But, on the other hand, it's nice to have the media last longer.

So, maybe it would be a good idea to have a 'delaysync=60' to force a
sync after 60 seconds of inactivity.  Unless, there is something else
that would do that for me already.

Thoughts?

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
