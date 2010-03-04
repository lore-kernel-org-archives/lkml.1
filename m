Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0CDECw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:02:52 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:47734 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab0CDECi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:02:38 -0500
Message-ID: <4B8F3056.1010109@oracle.com>
Date: Wed, 03 Mar 2010 20:00:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH -next] bridge: depends on INET
References: <20100302180915.1388d3f3.sfr@canb.auug.org.au> <4B8D4607.8070603@xenotime.net> <20100303.012359.66790294.davem@davemloft.net> <20100304031847.GA22683@elte.hu>
In-Reply-To: <20100304031847.GA22683@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0201.4B8F30C3.0034:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/10 19:18, Ingo Molnar wrote:
> 
> * David Miller <davem@davemloft.net> wrote:
> 
>> From: Randy Dunlap <rdunlap@xenotime.net>
>> Date: Tue, 02 Mar 2010 09:08:23 -0800
>>
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> br_multicast calls ip_send_check(), so it should depend on INET.
>>>
>>> built-in:
>>> br_multicast.c:(.text+0x88cf4): undefined reference to `ip_send_check'
>>>
>>> or modular:
>>> ERROR: "ip_send_check" [net/bridge/bridge.ko] undefined!
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Applied, but I almost lost this patch.
>>
>> You need to CC: netdev on all networking patches so that it
>> gets properly tracked in patchwork and therefore does not get
>> lost.
> 
> I suspect Randy went by the MAINTAINERS entry - you might want to add netdev 
> as a second 'L:' line:
> 
>  ETHERNET BRIDGE
>  M:      Stephen Hemminger <shemminger@linux-foundation.org>
>  L:      bridge@lists.linux-foundation.org
>  W:      http://www.linux-foundation.org/en/Net:Bridge
>  S:      Maintained
>  F:      include/linux/netfilter_bridge/
>  F:      net/bridge/
> 
> To make it really clear that netdev must be Cc:-ed for those patches.

Ack that.  I also expected Stephen to merge it...

-- 
~Randy
