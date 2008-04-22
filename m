Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbYDVWYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbYDVWYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYDVWXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:23:50 -0400
Received: from s36.avahost.net ([74.53.95.194]:39458 "EHLO s36.avahost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYDVWXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:23:49 -0400
Message-ID: <480E6563.9020109@katalix.com>
Date: Tue, 22 Apr 2008 23:23:31 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Paul Fulghum <paulkf@microgate.com>,
       Krzysztof Halasa <khc@pm.waw.pl>
CC: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <20080412115950.1cbb9cfa@core>	<m33apqomgf.fsf@maximus.localdomain>	<m33apjp32f.fsf@maximus.localdomain>	<20080418.153256.253949503.davem@davemloft.net>	<m3ve2b9qe8.fsf@maximus.localdomain> <480CEB7D.8070702@katalix.com> <m33apdyajf.fsf@maximus.localdomain> <480E5CB3.2080003@microgate.com> <480E4FA1.5020508@garzik.org>
In-Reply-To: <480E4FA1.5020508@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s36.avahost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - katalix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Paul Fulghum wrote:
>> Krzysztof Halasa wrote:
>>> It's complex, I think kernel interface to generic HDLC would mean more
>>> code than PPP implementation required for fixed lines.
>>> Additional requirement - userspace daemon with additional plugin - may
>>> not be the best thing for fixed lines either.
>>>
>>> That would break backward compatibility, too.
>>
>> I maintain both pppd and generic HDLC PPP
>> interfaces for the synclink drivers.
>> I would like to have a single PPP implementation,
>> but what Krzysztof writes about compatibility and complexity
>> (both in coding and user configuration) is a real issue.
>>
>> Many customers who choose to use generic HDLC PPP are *dead*
>> set against the added complexity and (user space)
>> components of using pppd even though it has more features.
>> I say that having tried to persuade such users to use pppd.
>> The response is usually "support the simpler generic
>> HDLC PPP way of doing things or we will go elsewhere".
>> Others require the extra features of pppd.
>>
>> I understand customer desires are not always rational
>> or a primary concern when making these architectural
>> decisions, but I know forcing the extra complexity and
>> components of pppd on generic HDLC users will cause a
>> lot of anger and defections.

Are there technical reasons or is the complexity just a lack of familiarity?

> The fact that Krzysztof's solution was _small_ and _clean_ and easily 
> maintainable was the reason I merged it [into my tree].
> 
> IMO sometimes "one size fits all" is not the best solution.

I guess what caught my eye is a PPP control protocol implementation 
being in the kernel. I'd seen syncppp before but I assumed it was there 
for legacy reasons. A while ago there seemed to be strong desire to move 
control protocols such as bridge spanning tree into userspace. Is this 
no longer the case?

-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

