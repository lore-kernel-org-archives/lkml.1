Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYFQMDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYFQMDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYFQMDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:03:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51894 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYFQMDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:03:42 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <18509098.1213704200391.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 17 Jun 2008 21:03:20 +0900 (JST)
To: balbir@linux.vnet.ibm.com
Subject: Re: Re: [PATCH 2/2] memcg: reduce usage at change limit
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, xemul@openvz.org,
       menage@google.com, lizf@cn.fujitsu.com, yamamoto@valinux.co.jp,
       nishimura@mxp.nes.nec.co.jp, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <48578E9D.4050903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <48578E9D.4050903@linux.vnet.ibm.com>
 <20080617123144.ce5a74fa.kamezawa.hiroyu@jp.fujitsu.com> <20080617123604.c8cb1bd5.kamezawa.hiroyu@jp.fujitsu.com> <48573397.608@linux.vnet.ibm.com> <20080617130656.bcd3ca85.kamezawa.hiroyu@jp.fujitsu.com> <20080617190055.2b55ba0b.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>Date: 	Tue, 17 Jun 2008 15:44:53 +0530
>From: Balbir Singh <balbir@linux.vnet.ibm.com>
>KAMEZAWA Hiroyuki wrote:
>
>>> I'll repost later, today.
>>>
>> I'll postpone this until -mm is settled ;)
>> 
>
>Sure, by -mm is settled you mean scalable page reclaim, fast GUP and lockless
>read size for pagecache? Is there something else I am unaware of?
>
Ah, some panics are added ;)
It's my main concern.  And I have to study new VM LRU management
scheme and check whether there are something to be fixed(updated)
around memcg. 

Anyway, I'd like to push this patch before too late. I just stop
for a while (because -mm has trouble).

Thanks,
-Kame
