Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbXHDKeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbXHDKeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 06:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXHDKeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 06:34:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbXHDKeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 06:34:09 -0400
Date: Sat, 4 Aug 2007 12:33:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070804103347.GA1956@elte.hu>
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804070737.GA940@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> [ my personal interest in this is the following regression: every time 
>   i start a large kernel build with DEBUG_INFO on a quad-core 4GB RAM 
>   box, i get up to 30 seconds complete pauses in Vim (and most other 
>   tasks), during plain editing of the source code. (which happens when 
>   Vim tries to write() to its swap/undo-file.) ]

hm, it turns out that it's due to vim doing an occasional fsync not only 
on writeout, but during normal use too. "set nofsync" in the .vimrc 
solves this problem.

	Ingo
