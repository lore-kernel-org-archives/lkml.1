Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYJNLvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYJNLvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYJNLvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:51:25 -0400
Received: from stinky.trash.net ([213.144.137.162]:33769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYJNLvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:51:23 -0400
Message-ID: <48F487B7.3070004@trash.net>
Date: Tue, 14 Oct 2008 13:51:19 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>, shemminger@linux-foundation.org,
       netdev@vger.kernel.org, containers@lists.linux-foundation.org,
       kaber@trash.et, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [bug, -git] ERROR: "ebt_unregister_table"	[net/bridge/netfilter/ebtable_nat.ko]
 undefined
References: <20080821221943.GO31136@x200.localdomain> <20081013070347.GA3813@elte.hu> <20081013070940.GA6340@elte.hu> <20081013073501.GB4254@x200.localdomain> <20081014103005.GA19420@elte.hu> <48F47BB9.9090902@trash.net> <20081014114806.GA20480@elte.hu>
In-Reply-To: <20081014114806.GA20480@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Patrick McHardy <kaber@trash.net> wrote:
> 
>> Ingo Molnar wrote:
>>> i think you misunderstood my report. This is about latest upstream -git 
>>> being broken:
>>>
>>> ERROR: "ebt_register_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
>>> ERROR: "ebt_do_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
>>> ERROR: "ebt_unregister_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
>>> ERROR: "ebt_register_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
>>> ERROR: "ebt_do_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
>>> ERROR: "ebt_unregister_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
>>> make[1]: *** [__modpost] Error 1
>>> make: *** [modules] Error 2
>>>
>> Does this patch fix it?
> 
> yeah, the module build now succeeds fine with that config, thanks 
> Patrick!
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks Ingo, I'll send it upstream tonight.
