Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZENXs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZENXs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZENXst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:48:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56715 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZENXss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:48:48 -0400
Date: Fri, 15 May 2009 08:47:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] fix stale swap cache account leak  in memcg v7
Message-Id: <20090515084716.544930d9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090513093127.4dadac97.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090512104401.28edc0a8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090512095158.GB6351@balbir.in.ibm.com>
	<20090513093127.4dadac97.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 09:31:27 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 12 May 2009 15:21:58 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > > The patch set includes followng
> > >  [1/3] add mem_cgroup_is_activated() function. which tell us memcg is _really_ used.
> > >  [2/3] fix swap cache handling race by avoidng readahead.
> > >  [3/3] fix swap cache handling race by check swapcount again.
> > > 
> > > Result is good under my test.
> > 
> > What was the result (performance data impact) of disabling swap
> > readahead? Otherwise, this looks the most reasonable set of patches
> > for this problem.
> > 
> I'll measure some and report it in the next post.
> 
I confirmed there are cases which swapin readahead works very well....

Nishimura-san, could you post a patch for fixing leak at writeback ? as [3/3]
I'd like to fix readahead case...with some large patch.

Hm, I didn't think this problem took 2 months to be fixed ;(

-Kame

