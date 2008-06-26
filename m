Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYFZBv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYFZBv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYFZBvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:51:16 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39366 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYFZBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:51:15 -0400
Message-ID: <4862F5BB.9030200@ah.jp.nec.com>
Date: Thu, 26 Jun 2008 10:49:47 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: MinChan Kim <minchan.kim@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] prevent incorrect oom under split_lru
References: <20080624092824.4f0440ca@bree.surriel.com>	 <28c262360806242259k3ac308c4n7cee29b72456e95b@mail.gmail.com>	 <20080625150141.D845.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <28c262360806242356n3f7e02abwfee1f6acf0fd2c61@mail.gmail.com>	 <1214395885.15232.17.camel@twins> <28c262360806250605le31ba48ma8bb16f996783142@mail.gmail.com>
In-Reply-To: <28c262360806250605le31ba48ma8bb16f996783142@mail.gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MinChan Kim wrote:
> Hi peter,
> 
> I agree with you.  but if application's virtual address space is big,
> we have a hard problem with mlockall since memory pressure might be a
> big.
> Of course, It will be a RT application design problem.
> 
>> The much more important case is desktop usage - that is where we run non
>> real-time code, but do expect 'low' latency due to user-interaction.
>>
>> >From hitting swap on my 512M laptop (rather frequent occurance) I know
>> we can do better here,..
>>
> 
> Absolutely. It is another example. So, I suggest following patch.
> It's based on idea of Takenori Nagano's memory reclaim more efficiently.

Hi Kim-san,

Thank you for agreeing with me.

I have one question.
My patch don't mind priority. Why do you need "priority == 0"?

Thanks,
  Takenori
