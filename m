Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYH1UqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYH1UqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYH1Upr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:45:47 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:48645 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbYH1Upp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:45:45 -0400
Message-ID: <48B70E74.2000800@hp.com>
Date: Thu, 28 Aug 2008 13:45:40 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jmalicki@metacarta.com, andi@firstfloor.org, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, denys@visp.net.lb, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <48B6E7D0.5070307@hp.com>	<20080828.124251.149964287.davem@davemloft.net>	<48B70AAA.7010504@hp.com> <20080828.133223.119110675.davem@davemloft.net>
In-Reply-To: <20080828.133223.119110675.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Rick Jones <rick.jones2@hp.com>
> Date: Thu, 28 Aug 2008 13:29:30 -0700
> 
> 
>>Has the request "hit the trading system" when it hits the NIC, or
>>when it hits the application executing the trade?  If the SEC calls
>>for when it hits the NIC, then none of what is done today is really
>>accurate/correct and one would need to start using NIC HW
>>timestamps, synchronized with the host and the other NICs in the
>>system no?
> 
> 
> The SEC isn't mandating anything here, stop framing it that way :-)

Must be my DC upbringing.  I figured that if the logic wasn't 100% 
concrete a US Federal Bureaucracy must be involved :)

> People simply won't trade with a firm if they find out that trades
> there are executed out of order.
> 
> They are simply trying to make things as fair as possible.

But that is the very crux of the question - exactly where is "in order" 
to be determined?  Is it supposed to be arrival time at the NIC HW, 
initial notice by the driver, or initial notice by the trading application?

Given that there are no guarantees that a packet arriving on NIC 1 and 
timestamped either by the NIC HW or the driver will actually hit the 
application before a packet arriving on NIC2, just how long are these 
financial services applications going to wait around before executing 
the trade carried in the packet arriving on NIC1?

rick jones
