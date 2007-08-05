Return-Path: <linux-kernel-owner+w=401wt.eu-S1765066AbXHEK7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765066AbXHEK7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 06:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764390AbXHEK6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 06:58:54 -0400
Received: from unthought.net ([212.97.129.88]:3357 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764307AbXHEK6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 06:58:51 -0400
Date: Sun, 5 Aug 2007 12:58:50 +0200
From: Jakob Oestergaard <jakob@unthought.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805105850.GC4246@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, miklos@szeredi.hu,
	akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
	tomoki.sekiyama.qu@hitachi.com, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	nikita@clusterfs.com, trond.myklebust@fys.uio.no,
	yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
References: <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070805102021.GA4246@unthought.net> <46B5A996.5060006@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B5A996.5060006@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 06:42:30AM -0400, Jeff Garzik wrote:
...
> If you can show massive amounts of users that will actually be 
> negatively impacted, please present hard evidence.
> 
> Otherwise all this is useless hot air.

Peace Jeff  :)

In another mail, I gave an example with tmpreaper clearing out unused
files; if some of those files are only read and never modified,
tmpreaper would start deleting files which were still frequently used.

That's a regression, the way I see it. As for 'massive amounts of
users', well, tmpreaper exists in most distros, so it's possible it has
other users than just me.

-- 

 / jakob

