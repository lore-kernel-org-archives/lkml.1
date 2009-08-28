Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbZH1O3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbZH1O3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZH1O3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:29:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48579 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZH1O3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:29:10 -0400
Message-ID: <bfd50d44ff730c2720b882a81b7446c6.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090828132643.GM4889@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132321.e4a497bb.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828072007.GH4889@balbir.in.ibm.com>
    <20090828163523.e51678be.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132643.GM4889@balbir.in.ibm.com>
Date: Fri, 28 Aug 2009 23:29:09 +0900 (JST)
Subject: Re: [RFC][PATCH 1/5] memcg: change for softlimit.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> 16:35:23]:
>

>>
>> Current soft-limit RB-tree will be easily broken i.e. not-sorted
>> correctly
>> if used under use_hierarchy=1.
>>
>
> Not true, I think the sorted-ness is delayed and is seen when we pick
> a tree for reclaim. Think of it as being lazy :)
>
plz explain how enexpectedly unsorted RB-tree can work sanely.


>> My patch disallows set softlimit to Bob and Mike, just allows against
>> Gold
>> because there can be considered as the same class, hierarchy.
>>
>
> But Bob and Mike might need to set soft limits between themselves. if
> soft limit of gold is 1G and bob needs to be close to 750M and mike
> 250M, how do we do it without supporting what we have today?
>
Don't use hierarchy or don't use softlimit.
(I never think fine-grain  soft limit can be useful.)

Anyway, I have to modify unnecessary hacks for res_counter of softlimit.
plz allow modification. that's bad.
I postpone RB-tree breakage problem, plz explain it or fix it by yourself.

Thanks,
-Kame

