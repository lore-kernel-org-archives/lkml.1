Return-Path: <linux-kernel-owner+w=401wt.eu-S933073AbXA2BbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbXA2BbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933090AbXA2BbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:31:01 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:46077 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbXA2Ba7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:30:59 -0500
Message-ID: <45BD4C72.70000@oracle.com>
Date: Sun, 28 Jan 2007 17:22:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: David Miller <davem@davemloft.net>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, netfilter@lists.netfilter.org,
       netdev@vger.kernel.org, kaber@trash.net
Subject: Re: [2.6 patch] NF_CONNTRACK_H323 must depend on (IPV6 || IPV6=n)
References: <20070128222136.GZ6017@stusta.de> <20070128.155348.39160134.davem@davemloft.net> <20070129000011.GB6017@stusta.de> <20070128.160442.48527586.davem@davemloft.net> <20070129002108.GC6017@stusta.de>
In-Reply-To: <20070129002108.GC6017@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 28, 2007 at 04:04:42PM -0800, David Miller wrote:
>> From: Adrian Bunk <bunk@stusta.de>
>> Date: Mon, 29 Jan 2007 01:00:11 +0100
>>
>>> On Sun, Jan 28, 2007 at 03:53:48PM -0800, David Miller wrote:
>>>> Adrian is this the correct way to constrain the selection between
>>>> "n" and "m" in this kind of situation?  I thought doing something
>>>> like "depends on IPV6" is sufficient to achieve that?
>>> "depends on IPV6" would fix the bug - but it would also make 
>>> NF_CONNTRACK_H323 unavailable for all people without IPV6 support in 
>>> their kernel.
>> Yes, that is an issue.
>>
>> I guess with some slightly ugly ifdefs we could support the
>> whole matrix of possibilities.  But perhaps that's undesirable
>> for another reason.
>> ...
> 
> This depends on what NF_CONNTRACK_H323=y, IPV6=m is supposed to be:
> - not allowed (NF_CONNTRACK_H323 must be modular) or
> - NF_CONNTRACK_H323 can only be used for IPV4
> 
> My patch implements the first case.

Sorry for the slow reponse.  This bug only came up due to my
bad gfs2/dlm patch, which Adrian has now corrected, so I think
you can just drop this patch.  It now builds for me with only
Adrian's gfs2/dlm patch applied.

-- 
~Randy
