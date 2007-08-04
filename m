Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbXHDTv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbXHDTv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765360AbXHDTvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:51:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55840 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762892AbXHDTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:51:18 -0400
Date: Sat, 4 Aug 2007 12:49:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
In-Reply-To: <alpine.LFD.0.999.0708041246530.5037@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708041247540.5037@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
 <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu>
 <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
 <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
 <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org>
 <20070804192130.GA25346@elte.hu> <20070804192615.GA25600@lazybastard.org>
 <alpine.LFD.0.999.0708041246530.5037@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Aug 2007, Linus Torvalds wrote:
> 
> Well, we could make it the default for the kernel (possibly under a 
> "fast-atime" config option), and then people can add "atime" or "noatime" 
> as they wish, since mount has supported _those_ options for a long time.

Side note: while I think the fsync() behaviour is more irritating than 
atime, that one is harder to fix. I think it's reasonable to have 
"relatime" as a default strategy for the kernel, but I don't think it's 
necessarily at all as reasonable to change a filesystem-specific ordering 
constraint.

			Linus
