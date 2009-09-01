Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZIAQcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZIAQcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZIAQcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:32:13 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:52209 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZIAQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:32:13 -0400
Date: Tue, 1 Sep 2009 22:01:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 0/4] memcg: add support for hwpoison testing
Message-ID: <20090901163152.GC5022@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090831102640.092092954@intel.com>
 <20090901084626.ac4c8879.kamezawa.hiroyu@jp.fujitsu.com>
 <20090901022514.GA11974@localhost>
 <20090901113214.60e7ae32.kamezawa.hiroyu@jp.fujitsu.com>
 <20090901064652.GA20342@localhost>
 <20090901161228.9fb33234.kamezawa.hiroyu@jp.fujitsu.com>
 <20090901085549.GA4454@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090901085549.GA4454@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang <fengguang.wu@intel.com> [2009-09-01 16:55:49]:

> > My point is that memcg can show 'owner' of pages but the page may
> > be shared with something important task _and_ if a task is migrated,
> > its pages' memcg information is not updated now. Then, you can kill
> > a task which is not in memcg.
> 
> Ah thanks! I'm not aware of that tricky fact, and it does make a
> very good reason not to use memcg, although I guess locked page won't
> be migrated.
>

I think what Kamezawa-San is pointing to is that the task can migrate,
leaving behind the page in the memcg and poisioning those pages can
kill a task outside the memcg. 

-- 
	Balbir
