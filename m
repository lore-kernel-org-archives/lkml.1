Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbZCaBss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbZCaBss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZCaBsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:48:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49792 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbZCaBsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:48:38 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan: rename  sc.may_swap to may_unmap)
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20090331104237.e689f279.kamezawa.hiroyu@jp.fujitsu.com>
References: <28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com> <20090331104237.e689f279.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090331104625.B1C7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 31 Mar 2009 10:48:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Sorry for too late response.
> > I don't know memcg well.
> > 
> > The memcg managed to use may_swap well with global page reclaim until now.
> > I think that was because may_swap can represent both meaning.
> > Do we need each variables really ?
> > 
> > How about using union variable ?
> 
> or Just removing one of them  ?

I hope all may_unmap user convert to using may_swap.
may_swap is more efficient and cleaner meaning.



