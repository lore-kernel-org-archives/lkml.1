Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZC1QKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZC1QKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 12:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZC1QKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 12:10:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36413 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZC1QKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 12:10:41 -0400
Message-ID: <cb947346323dc0c602b6aad8eec13263.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090328082350.GS24227@balbir.in.ibm.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
    <20090328082350.GS24227@balbir.in.ibm.com>
Date: Sun, 29 Mar 2009 01:10:37 +0900 (JST)
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
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
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27
> 13:59:33]:

>>   When vm.swappiness = 60  => 60MB of memory are swapped out from B.
>>   When vm.swappiness = 10  => 1MB of memory are swapped out from B
>>
>>   If no soft limit, 350MB of swap out will happen from B.(swapiness=60)
>>
>
> How did you calculate the swap usage of group B?
>
 memsory.memsw.usage_in_bytes - memory.usage_in_bytes.

>> I'll try much more complexed ones in the weekend.
>
> You might want to try experiments where the group with the higher soft
> limit starts much later than the group with lower soft limit and both
> have a high demand for memory. Also try corner cases such as soft
> limits being 0, or groups where soft limits are equal, etc.
>
thx, good input. maybe I need some hook in "set soft limit" path.

> We have a long weekend, so I've been unable to test/review your
> patches. I'll do so soon if possible.
>
thank you.
-Kame

> --
> 	Balbir
>


