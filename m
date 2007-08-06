Return-Path: <linux-kernel-owner+w=401wt.eu-S1765936AbXHFSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765936AbXHFSSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbXHFSSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:18:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbXHFSSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:18:44 -0400
Message-ID: <46B7626C.6050403@redhat.com>
Date: Mon, 06 Aug 2007 14:03:24 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, J??rn Engel <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804192615.GA25600@lazybastard.org> <20070804194259.GA25753@lazybastard.org> <20070805203602.GB25107@infradead.org>
In-Reply-To: <20070805203602.GB25107@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2007 04:36 PM, Christoph Hellwig wrote:
> 
> Umm, no f**king way.  atime selection is 100% policy and belongs into
> userspace.  Add to that the problem that we can't actually re-enable
> atimes because of the way the vfs-level mount flags API is designed.
> Instead of doing such a fugly kernel patch just talk to the handfull
> of distributions that matter to update their defaults.
> 

We already tried that here. The response: "If noatime is so great, why
isn't it the default in the kernel?"
