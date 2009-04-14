Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZDNHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZDNHma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZDNHmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:42:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59914 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZDNHmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:42:20 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH] proc: export more page flags in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090414072231.GA7001@localhost>
References: <20090414154606.C665.A69D9226@jp.fujitsu.com> <20090414072231.GA7001@localhost>
Message-Id: <20090414163312.C674.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 16:42:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > > - PG_unevictable
> > > > > - PG_mlocked
>  
> How about including PG_unevictable/PG_mlocked?
> They shall be meaningful to administrators.

I explained another mail. please see it.


> > this 9 flags shouldn't exported.
> > I can't imazine administrator use what purpose those flags.
> 
> > > > > - PG_swapcache
> > > > > - PG_swapbacked
> > > > > - PG_poison
> > > > > - PG_compound
> >
> > I can agree this 4 flags.
> > However pagemap lack's hugepage considering.
> > if PG_compound exporting, we need more work.
> 
> You mean to fold PG_head/PG_tail into PG_COMPOUND?
> Yes, that's a good simplification for end users.

Yes, I agree.


> > > > > - PG_NOPAGE: whether the page is present
> > 
> > PM_NOT_PRESENT isn't enough?
> 
> That would not be usable if you are going to do a system wide scan.
> PG_NOPAGE could help differentiate the 'no page' case from 'no flags'
> case.
> 
> However PG_NOPAGE is more about the last resort. The system wide scan
> can be made much more efficient if we know the exact memory layouts.

Yup :)


