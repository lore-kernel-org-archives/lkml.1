Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZCLR5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZCLR5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZCLR46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:56:58 -0400
Received: from mail2.shareable.org ([80.68.89.115]:35858 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZCLR45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:56:57 -0400
Date: Thu, 12 Mar 2009 17:55:57 +0000
From: Jamie Lokier <jamie@shareable.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Rik van Riel <riel@surriel.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: [uClinux-dev] Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Message-ID: <20090312175557.GD14491@shareable.org>
References: <20090311170207.1795cad9.akpm@linux-foundation.org> <28c262360903111735s2b0c43a3pd48fcf8d55416ae3@mail.gmail.com> <20090312100049.43A3.A69D9226@jp.fujitsu.com> <200903120819.08724.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903120819.08724.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:
> > Currently, CONFIG_UNEVICTABLE_LRU can't use on nommu machine
> > because nobody of vmscan folk havbe nommu machine.
> > 
> > Yes, it is very stupid reason. _very_ welcome to tester! :)
> 
> As always - if you (or any kernel developer) would like a noMMU machine to 
> test on - please send me a private email.

Well, that explains why vmscan has historically performed a little
dubiously on small nommu machines!

By the way, this is just a random side thought... nommu kernels work
just fine in emulators :-)

-- Jamie
