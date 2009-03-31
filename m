Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbZCaG7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbZCaG7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZCaG7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:59:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51972 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZCaG7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:59:44 -0400
Date: Tue, 31 Mar 2009 15:58:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
Message-Id: <20090331155810.85bfb987.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090331064901.GK16497@balbir.in.ibm.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090328181100.GB26686@balbir.in.ibm.com>
	<20090328182747.GA8339@balbir.in.ibm.com>
	<20090331085538.2aaa5e2b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331050055.GF16497@balbir.in.ibm.com>
	<20090331140502.813993cc.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331061010.GJ16497@balbir.in.ibm.com>
	<20090331152843.e1db942b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331064901.GK16497@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 12:19:02 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > >  At some point, memcg soft limit reclaim
> > > hits A and reclaims memory from it, allowing B to run without any
> > > problems. I am talking about the state at the end of the experiment.
> > > 
> > Considering LRU rotation (ACTIVE->INACTIVE), pages in group B never goes back
> > to ACTIVE list and can be the first candidates for swap-out via kswapd.
> > 
> > Hmm....kswapd doesn't work at all ?
> > 
> > (or 1700MB was too much.)
> >
> 
> No 1700MB is not too much, since we reclaim from A towards the end
> when ld runs. I need to investigate more and look at the watermarks,
> may be soft limit reclaim reclaims enough and/or the watermarks are
> not very high. I use fake NUMA nodes as well.
>  
When talking about XXMB of swap, +100MB is much ;)

-Kame

