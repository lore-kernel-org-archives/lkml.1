Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbYFDRv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbYFDRv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYFDRvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:51:48 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:32430 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbYFDRvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:51:47 -0400
Message-ID: <4846D632.4030803@ct.jp.nec.com>
Date: Wed, 04 Jun 2008 10:51:46 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] per-task-delay-accounting: add memory reclaim delay
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp> <20080604115917.9408.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080604115917.9408.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
>> +	delayacct_freepages_start();
>>  	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
>> +	delayacct_freepages_end();
> 
> Shouldn't we consider memcgroup reclaim?

thanks for pointing this.
Unfortunately, we're not so familiar to memcgroup.
Will look into this.
Could you tell us pointers to memcgroup?

Thanks,
Hiroshi Shimamoto
