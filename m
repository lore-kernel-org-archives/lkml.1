Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbXEJIyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbXEJIyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbXEJIyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:54:06 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44677 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553AbXEJIyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:54:04 -0400
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
From: Richard Purdie <richard@openedhand.com>
To: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
In-Reply-To: <1178785576.28494.17.camel@pmac.infradead.org>
References: <1178096183.5860.25.camel@localhost.localdomain>
	 <20070509232129.371f49d5.akpm@linux-foundation.org>
	 <1178785576.28494.17.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 09:53:44 +0100
Message-Id: <1178787224.5828.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 09:26 +0100, David Woodhouse wrote:
> On Wed, 2007-05-09 at 23:21 -0700, Andrew Morton wrote:
> > Well that's attractive-looking code.
> 
> It's compression code. I've never seen compression code look nice :)
> 
> > Why is this needed?  What code plans to use it?
> 
> I'm itching to use it in JFFS2. Richard claims a 10% boot time speedup
> and 40% improvement on file read speed, with only a slight drop in the
> file compression ratio (when compared to zlib).

Right, the speed improvement is noticeable and useful. JFFS2 is the
primary use case, I've also implemented a crypto interface for it.

> > How many buffer overruns are there in it?
> 
> That I'm afraid I cannot tell you.

There is a "safe" decompression function which does bounds checking so
its at least been thought about by the author. The code has been around
in userspace for a while so hopefully any issues have been ironed out
before now.

Richard

