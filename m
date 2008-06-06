Return-Path: <linux-kernel-owner+w=401wt.eu-S932885AbYFFV6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbYFFV6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbYFFV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:58:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4446 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbYFFV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:58:08 -0400
Message-ID: <4849B2EC.5070405@ct.jp.nec.com>
Date: Fri, 06 Jun 2008 14:58:04 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, nagar@watson.ibm.com, balbir@in.ibm.com,
       sekharan@us.ibm.com, kosaki.motohiro@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 2/3 v2] per-task-delay-accounting: update taskstats for
 memory reclaim delay
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp> <20080605163220.8397bed6.kobayashi.kk@ncos.nec.co.jp> <4848B983.4030502@linux.vnet.ibm.com>
In-Reply-To: <4848B983.4030502@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Keika Kobayashi wrote:
>> Add members for memory reclaim delay to taskstats,
>> and accumulate them in __delayacct_add_tsk() .
>>
>> Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
> 
> Two suggested changes
> 
> 1. Please add all fields at the end (otherwise we risk breaking compatibility)
> 2. please also update Documentation/accounting/taskstats-struct.txt
> 
And update TASKSTATS_VERSION, right?

Thanks,
Hiroshi Shimamoto
