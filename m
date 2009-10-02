Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZJBIUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZJBIUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbZJBIUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:20:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:57702 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbZJBIUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:20:40 -0400
Message-ID: <4AC5B826.80105@suse.de>
Date: Fri, 02 Oct 2009 13:51:58 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/31] Swap over NFS -v20
References: <1254405858-15651-1-git-send-email-sjayaraman@suse.de> <20091001174201.GA30068@infradead.org>
In-Reply-To: <20091001174201.GA30068@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Oct 01, 2009 at 07:34:18PM +0530, Suresh Jayaraman wrote:
> 
> The other really big one is adding a proper method for safe, page-backed
> kernelspace I/O on files.  That is not something like the grotty
> swap-tied address_space operations in this patch, but more something in

I'm not sure I understood about what problems you see with the proposed
address_space operations. Could you please elaborate a bit more?

> the direction of the kernel direct I/O patches from Jenx Axboe he did
> for using in the loop driver.  But even those aren't complete as they
> don't touch the locking issue yet.
> 

Thanks,

-- 
Suresh Jayaraman
