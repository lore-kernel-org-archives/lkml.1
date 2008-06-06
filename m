Return-Path: <linux-kernel-owner+w=401wt.eu-S1763960AbYFFDmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763960AbYFFDmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 23:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYFFDmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 23:42:47 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:56813 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbYFFDmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 23:42:46 -0400
Message-ID: <4848B1DA.3060906@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2008 09:11:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, balbir@in.ibm.com, sekharan@us.ibm.com,
       kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/3 v2] per-task-delay-accounting: add memory reclaim
 delay
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp> <48489E71.2060708@linux.vnet.ibm.com> <20080605202132.d84b7083.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080605202132.d84b7083.kobayashi.kk@ncos.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keika Kobayashi wrote:
> On Fri, 06 Jun 2008 07:48:25 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>>     $ ./delayget -d -p <pid>
>>>     CPU             count     real total  virtual total    delay total
>>>                      2640     2456153500     2478353004       28366219
>>>     IO              count    delay total
>>>                      2628    19894214188
>>>     SWAP            count    delay total
>>>                         0              0
>>>     RECLAIM         count    delay total
>>>                      6600    10682486085
>>>
>> Looks interesting, this data is for the whole system or memcgroup? If it is for
>> memcgroup, we should be using cgroupstats.
> 
> Thanks for your comment.
> This accounting, which is named "RECLAIM", is global and memcgroup reclaim delay
> and this data is value per task.
> 
> Unfortunately, I'm not sure what the whole system means.
> Could you tell me your point?

By whole system, I meant global reclaim.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
