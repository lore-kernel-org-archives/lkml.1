Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYLLH7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYLLH7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYLLH7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:59:06 -0500
Received: from brick.kernel.dk ([93.163.65.50]:1821 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbYLLH7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:59:04 -0500
Date: Fri, 12 Dec 2008 08:58:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>, riel@redhat.com
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Message-ID: <20081212075844.GH23742@kernel.dk>
References: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081211113646.GI23742@kernel.dk> <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11 2008, KOSAKI Motohiro wrote:
> > On Thu, Dec 11 2008, KOSAKI Motohiro wrote:
> > > > > No objection from me, getting rid of configuration options almost
> > > > > always gets my vote :)
> > > > 
> > > > Yeah, mine too. One recent addition was CONFIG_UNEVICTABLE_LRU - why on
> > > > earth is that an option?!
> > > 
> > > As far as I know, CONFIG_UNEVICTABLE_LRU depend on CONFIG_MMU
> > > because any unevictable lru developer don't have nommu machine ;)
> > > 
> > > I expect that nobody of mmu user don't turn off unevictable lru feature.
> > 
> > Perhaps I didn't frase the question correctly. My question is, why is it
> > a visible option? Does it make ANY sense to turn off
> > CONFIG_UNEVICTABLE_LRU?
> 
> very difficult question...
> 
> As far as I know, CONFIG_UNEVICTABLE_LRU doesn't have any bad side effect.
> So, I expect we can remove UNEVICTABLE_LRU Kconfig option in the future.
> 
> but it is _not_ VM developr consensus. just my thinking.

Me neither, lets ask the originator of the patch. Rik, why is
unevictable lru an option?

-- 
Jens Axboe

