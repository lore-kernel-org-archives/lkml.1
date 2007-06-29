Return-Path: <linux-kernel-owner+w=401wt.eu-S1765592AbXF2MQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765592AbXF2MQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXF2MQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:16:14 -0400
Received: from hermes.domdv.de ([193.102.202.1]:4485 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051AbXF2MQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:16:13 -0400
Message-ID: <4684F80D.9070201@domdv.de>
Date: Fri, 29 Jun 2007 14:16:13 +0200
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net> <4684F3D8.1080800@domdv.de> <4684F4FB.9070807@trash.net> <4684F5D3.8020506@domdv.de> <4684F75E.90304@trash.net>
In-Reply-To: <4684F75E.90304@trash.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Andreas Steinmetz wrote:
>> Patrick McHardy wrote:
>>
>>> - assuming you have ethernet internally, the PMTU from your router
>>> to the internal hosts is 1500, so it won't do any clamping.
>>>
>>
>> Yep, internal PMTU is 1500, still the incoming packets are clamped to
>> 1452 on the one line and not clamped on the other.
>>
>>
>>> Does that explain it?
>>>
>>> A useful thing for TCPMSS for routers would be to clamp to the
>>> minimum of the PMTU of both directions. But thats not supported
>>> so far.
>>>
>>
>> I wonder, as somteimes it gets clamped. If it would never have been
>> clamped I wouldn't have asked.
> 
> 
> Its possible that one of your ISPs is doing clamping. You could

This would be fun as it is the same ISP for both lines. I'll check next
week as the lines are located 40km away.

> check on ppp0 if thats the case. Or maybe for some reason the
> PMTU value for the internal host is smaller than 1500. You can
> check that by doing "ip route get <internal host>".
> 

No. Unmodified internal network in both test cases.

> 


-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
