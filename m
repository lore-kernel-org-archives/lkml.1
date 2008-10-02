Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYJBI4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYJBI4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYJBIz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:55:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42570 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYJBIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:55:55 -0400
Date: Thu, 2 Oct 2008 18:02:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 0/6] memcg update v6 (for review and discuss)
Message-Id: <20081002180229.5bb94727.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 16:52:33 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This series is update from v5.
> 
> easy 4 patches are already posted as ready-to-go-series.
> 
> This is need-more-discuss set.
> 
> Includes following 6 patches. (reduced from v5).
> The whole series are reordered.
> 
> [1/6] make page_cgroup->flags to be atomic.
> [2/6] allocate all page_cgroup at boot.
> [3/6] rewrite charge path by charge/commit/cancel
> [4/6] new force_empty and move_account
> [5/6] lazy lru free
> [6/6] lazy lru add.
> 
> Patch [3/6] and [4/6] are totally rewritten.
> Races in Patch [6/6] is fixed....I think.
> 
> Patch [1-4] seems to be big but there is no complicated ops.
> Patch [5-6] is more racy. Check-by-regression-test is necessary.
> (Of course, I does some.)
> 
> If ready-to-go-series goes, next is patch 1 and 2.
> 

No terrible bugs until now on my test.

My current idea for next week is following.
(I may have to wait until the end of next merge window. If so, 
 I'll wait and maintain this set.)

 - post ready-to-go set again.
 - post 1/6 and 2/6 as may-ready-to-go set. I don't chagnge order of these.
 - reflects comments for 3/6. 
   patch 3/6 adds new functions. So, please tell me if you have better idea
   about new functions.
 - check logic for 4/6.
 - 5/6 and 6/6 may need some more comments in codes.
 - no new additional ones.


Thanks,
-Kame






