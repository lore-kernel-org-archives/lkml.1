Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbZH1Ok6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbZH1Ok6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZH1Ok5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:40:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53657 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZH1Ok4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:40:56 -0400
Message-ID: <712c0209222358d9c7d1e33f93e21c30.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <bfd50d44ff730c2720b882a81b7446c6.squirrel@webmail-b.css.fujitsu.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132321.e4a497bb.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828072007.GH4889@balbir.in.ibm.com>
    <20090828163523.e51678be.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132643.GM4889@balbir.in.ibm.com>
    <bfd50d44ff730c2720b882a81b7446c6.squirrel@webmail-b.css.fujitsu.com>
Date: Fri, 28 Aug 2009 23:40:56 +0900 (JST)
Subject: Re: [RFC][PATCH 1/5] memcg: change for softlimit.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
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

KAMEZAWA Hiroyuki wrote:
> Balbir Singh wrote:
>> But Bob and Mike might need to set soft limits between themselves. if
>> soft limit of gold is 1G and bob needs to be close to 750M and mike
>> 250M, how do we do it without supporting what we have today?
>>
> Don't use hierarchy or don't use softlimit.
> (I never think fine-grain  soft limit can be useful.)
>
> Anyway, I have to modify unnecessary hacks for res_counter of softlimit.
> plz allow modification. that's bad.
> I postpone RB-tree breakage problem, plz explain it or fix it by yourself.
>
I changed my mind....per-zone RB-tree is also broken ;)

Why I don't like broken system is a function which a user can't
know/calculate how-it-works is of no use in mission critical systems.

I'd like to think how-to-fix it with better algorithm. Maybe RB-tree
is not a choice.

Thanks,
-Kame

