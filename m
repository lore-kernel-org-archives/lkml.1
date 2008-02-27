Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYB0FFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYB0FFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYB0FFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:05:32 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48870 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYB0FFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:05:31 -0500
Date: Wed, 27 Feb 2008 14:04:15 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20080227140042.66abb805.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080227133850.4249.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080227140042.66abb805.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20080227140221.424C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > I don't think so.
> > all modern many cpu machine stand on NUMA.
> > it mean following,
> >  - if cpu increases, then zone increases, too.
> > 
> > if default value increase by #cpus, lock contension dramatically increase
> > on large numa.
> > 
> > Have I overlooked anything?
> > 
> How about adding something like..
> == 
> CONFIG_SIMULTANEOUS_PAGE_RECLAIMERS 
> int
> default 3
> depends on DEBUG
> help
>   This value determines the number of threads which can do page reclaim
>   in a zone simultaneously. If this is too big, performance under heavy memory
>   pressure will decrease.
>   If unsure, use default.
> ==
> 
> Then, you can get performance reports from people interested in this
> feature in test cycle.

hm, intersting.
but sysctl parameter is more better, i think.

OK, I'll add it at next post.



