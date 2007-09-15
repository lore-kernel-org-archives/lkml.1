Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbXIOIO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbXIOIO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbXIOIOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:14:46 -0400
Received: from verein.lst.de ([213.95.11.210]:33260 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbXIOIOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:14:45 -0400
Date: Sat, 15 Sep 2007 10:14:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: convert to generic sys_ptrace
Message-ID: <20070915081437.GA5251@lst.de>
References: <20070908191257.GA5075@lst.de> <20070915011150.0439a432.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915011150.0439a432.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 01:11:50AM -0700, Andrew Morton wrote:
> On Sat, 8 Sep 2007 21:12:57 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > This patch converts alpha to the generic sys_ptrace.  We use
> > force_successful_syscall_return to avoid having to pass the pt_regs
> > pointer down to the function.  I think the removal of the assemly
> > stub is correct, but I could only compile-test this patch, so please
> > give it a spin before commiting :)
> 
> Needed a bit of massaging due to consolidate-ptrace_detach.patch but
> it still compiles:

Btw,does alpha actually build for you sucessfully?  While I could get
the ptrace bits to compile 2.6.23-rc doesn't actually finish the build
for me due to missing syscalls and the brainded -Werror flag making this
fatal..

