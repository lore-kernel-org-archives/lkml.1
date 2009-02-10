Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbZBJLa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbZBJLa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbZBJLaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:30:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52224 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZBJLaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:30:13 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] memcg: remove mem_cgroup_reclaim_imbalance() perfectly
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090210110045.GE16317@balbir.in.ibm.com>
References: <20090210184538.6FCF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210110045.GE16317@balbir.in.ibm.com>
Message-Id: <20090210202939.6FEC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 20:30:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-02-10 18:50:39]:
> 
> > 
> > commit 4f98a2fee8acdb4ac84545df98cccecfd130f8db (vmscan: 
> > split LRU lists into anon & file sets) remove mem_cgroup_reclaim_imbalance().
> > 
> > but it isn't enough.
> > memcontrol.h header file still have legacy parts.
> > 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> > ---
> >  include/linux/memcontrol.h |    6 ------
> >  1 file changed, 6 deletions(-)
> >
> 
> The calc_mapped_ratio prototype should also be removed from this file. 

ok, thanks.
I'll do that soon.



