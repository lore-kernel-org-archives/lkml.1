Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbXGVCou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbXGVCou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXGVCon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:44:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbXGVCon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:44:43 -0400
Date: Sat, 21 Jul 2007 22:44:28 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Message-ID: <20070722024428.GA724@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
References: <20070721210005.000228000@chello.nl> <20070722023923.GA6438@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722023923.GA6438@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 10:39:23AM +0800, Fengguang Wu wrote:
 
 > It makes sense to raise it beyond 128K.  1M default readahead
 > absolutely makes sense for sequential workloads.  For the desktop,
 > this increases boot speed and readahead misses, both due to more
 > aggressive mmap read-around. Most users will be glad to feel the
 > speedup, and happily ignore the readahead misses, which may be
 > "invisible" in case of large memory.
 > 
 > In theory, the distributions can do the same tuning.  So we have an
 > interesting question for Dave:
 >         Does fedora desktop raise the default readahead size? Why or
 >         why not?  It goes so far to do userland readahead ;)
 
Fedora takes whatever defaults for readahead the kernel.org kernel has.
The only reasoning being if anyone reported VM bugs, we'd be able
to say to interested upstream developers "we're running the stock VM".
without having to get the user to try and reproduce on unpatched
kernels.
 
 > - drop behind
 > 
 > Sorry, I still doubt it will benefit all/most workloads. Leave it off
 > by default, and leave the enabling decision to Dave? I do hope that
 > it help general desktops.

It's not a subject that I'm intimatly familiar with, and when it
comes to decisions like this, I tend to just take whatever the
upstream defaults are.

	Dave

-- 
http://www.codemonkey.org.uk
