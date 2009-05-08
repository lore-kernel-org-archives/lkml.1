Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZEHQaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZEHQaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZEHQ3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:29:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46684 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbZEHQ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:29:50 -0400
Message-ID: <e100843048ef769085ac80ac03d19842.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090508230107.8dd680b3.d-nishimura@mtf.biglobe.ne.jp>
References: <20090508140528.c34ae712.kamezawa.hiroyu@jp.fujitsu.com>
    <20090508140910.bb07f5c6.kamezawa.hiroyu@jp.fujitsu.com>
    <20090508230107.8dd680b3.d-nishimura@mtf.biglobe.ne.jp>
Date: Sat, 9 May 2009 01:29:46 +0900 (JST)
Subject: Re: [PATCH 2/2] memcg fix stale swap cache account leak v6
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       d-nishimura@mtf.biglobe.ne.jp
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura wrote:
> On Fri, 8 May 2009 14:09:10 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

>>  - avoid swapin-readahead when memcg is activated.
> I agree that disabling readahead would be the easiest way to avoid type-1.
> And this patch looks good to me about it.
>
Thanks.

> But if we go in this way to avoid type-1, I think my patch(*1) would be
> enough to avoid type-2 and is simpler than this one.
> I've confirmed in my test that no leak can be seen with my patch and
> with setting page-cluster to 0.
>
> *1 http://marc.info/?l=linux-kernel&m=124115252607665&w=2
>
Ok, I'll merge yours on my set.
the whole patch set will be
  [1/3]  memcg_activated()
  [2/3]  avoid readahead
  [3/3]  your fix.

I'll post in the next week.

Thanks,
-Kame



