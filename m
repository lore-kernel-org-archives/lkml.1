Return-Path: <linux-kernel-owner+w=401wt.eu-S1764596AbXHCWW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764596AbXHCWW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763782AbXHCWWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:22:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762605AbXHCWWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:22:19 -0400
Date: Fri, 3 Aug 2007 15:21:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
In-Reply-To: <20070803123712.987126000@chello.nl>
Message-ID: <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
References: <20070803123712.987126000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Aug 2007, Peter Zijlstra wrote:
> 
> These patches aim to improve balance_dirty_pages() and directly address three
> issues:
>   1) inter device starvation
>   2) stacked device deadlocks
>   3) inter process starvation

Ok, the patches certainly look pretty enough, and you fixed the only thing 
I complained about last time (naming), so as far as I'm concerned it's now 
just a matter of whether it *works* or not. I guess being in -mm will help 
somewhat, but it would be good to have people with several disks etc 
actively test this out.

		Linus
