Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXHUUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXHUUH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXHUUHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:07:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60121 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXHUUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:07:13 -0400
Date: Tue, 21 Aug 2007 14:07:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <ak@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce TASK_SIZE_OF() for all arches
Message-ID: <20070821200711.GE9163@parisc-linux.org>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de> <20070821195433.GE30705@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821195433.GE30705@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 09:54:33PM +0200, Adrian Bunk wrote:
> We currently support 6 different stable gcc release series plus heavily 
> modified vendor branches like 3.3-hammer. We can discuss whether it is 
> now already the right time, and where to make the cut, but medium-term 
> we must reduce the number of supported compilers.

I don't think that's feasible.  We're dealing with a situation where:

 - GCC aim to release a new compiler series every 6 months.
   Fortunately, they don't achieve this goal, but they do release every
   12 months or thereabouts [1].
 - Enterprise distros are supported for seven years
 - We still care about people being able to compile kernels on
   enterprise distros that are still supported by their vendor.

Yes, it causes us some pain to support all these different compilers,
but it's not *that* big a pain.

[1] Release dates, according to the GCC website

2007-05-17 4.2.0	(14 months)
2006-02-28 4.1.0	(10 months)
2005-04-20 4.0.0	(12 months)
2004-04-20 3.4.0	(11 months)
2003-05-20 3.3		(12 months, ignoring gcc 3.2 which was really 3.1.2)
2002-05-15 3.1		(11 months)
2001-06-18 3.0

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
