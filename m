Return-Path: <linux-kernel-owner+w=401wt.eu-S935600AbXGXKiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935600AbXGXKiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 06:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933935AbXGXKhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 06:37:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:46673 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933124AbXGXKht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 06:37:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/W9XIh1iDWnRKX17/qw+ejvQLFn05YJRVbbOpPoQ
	hR0mO/JJpTkhbA
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1185271269.6479.7.camel@Homer.simpson.net>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <20070723183839.GA5874@martell.zuzino.mipt.ru>
	 <20070723190152.GA5755@martell.zuzino.mipt.ru>
	 <20070723132431.42afbae8.akpm@linux-foundation.org>
	 <1185271269.6479.7.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 12:37:48 +0200
Message-Id: <1185273468.6467.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 12:01 +0200, Mike Galbraith wrote:
> On Mon, 2007-07-23 at 13:24 -0700, Andrew Morton wrote:
> 
> > You're using DEBUG_PAGEALLOC, but I was not, so I think we can rule that out.
> 
> My box bugged during boot the first time I booted 23-rc1, but nothing
> made it to the console, and I didn't have a serial console running.  I
> didn't have DEBUG_PAGEALLOC or friends set.
> 
> > I haven't worked out where that kmap_atomic() call is coming from yet. 
> > Both traces point up into the page allocator, but I _think_ that's stack
> > gunk.
> 
> I just enabled all debug options, and was just rewarded with the below.

Hm.  I just also experienced filesystem corruption when I tried to send
from that kernel, and it bugged in the process.  My mount table ended up
in /etc/resolv.conf along with some binary goop, making nscd rather
unhappy after reboot.  fsck time.

	.Mike

