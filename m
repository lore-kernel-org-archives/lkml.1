Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYHTAYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYHTAYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYHTAYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:24:09 -0400
Received: from tau.jukie.net ([216.239.93.128]:59915 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbYHTAYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:24:08 -0400
Date: Tue, 19 Aug 2008 20:24:06 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
Message-ID: <20080820002406.GD28029@jukie.net>
References: <20080819220311.GA28029@jukie.net> <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org> <20080820000339.GB28029@jukie.net> <alpine.LFD.1.10.0808191709130.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808191709130.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [080819 20:12]:
> Btw, while you're at it, can you try doing some random writes to that 
> thing, since the whole sync mount is quite possibly going to find a few 
> other cases like this. 

My bisect test script moved files back and forth between the device and
my hard disk.  If the patch works, I'll modify the script to also do
some truncate and overwrite tests, and maybe do a few things in
parallel.

> IOW, _maybe_ you hit the only case that is ever going to be an issue for 
> sync mounts, and maybe you didn't. In my eternal quest to never actually 
> test anything myself, I'm hoping you can try some writing (and 
> over-writing) of files, since writes to the filesystem is where the whole 
> "sync" thing is going to show up (both metadata ie file creation and 
> removal, and "real" data ie normal write/truncate calls).

I am glad to help you in your eternal quest. :)

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
