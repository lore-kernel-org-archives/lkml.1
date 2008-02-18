Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYBRIEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYBRIEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYBRID7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:03:59 -0500
Received: from gate.cdi.cz ([80.95.109.117]:43272 "EHLO luxik.cdi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbYBRID5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:03:57 -0500
Message-ID: <47B93BE8.7010905@cdi.cz>
Date: Mon, 18 Feb 2008 09:03:52 +0100
From: Martin Devera <devik@cdi.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.24 1/1] sch_htb: fix "too many events" situation
References: <E1JPn6W-0002J2-5x@luxik.cdi.cz> <20080217.232829.222344360.davem@davemloft.net>
In-Reply-To: <20080217.232829.222344360.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.6 (--)
X-Spam-Report: * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> up to single jiffy interval and then delay remainder to other
>> jiffy.
>>
>> Signed-off-by: Martin Devera <devik@cdi.cz>
> 
> I think we would be wise to use something other than loops_per_jiffy.
> 
> Depending upon the loop calibration method used by a particular
> architecture it can me one of many different things.
> 
> Some platforms don't even make use of it and thus leave it at it's

aha, ok, I'm not so informed about crossplatform issues.
I was also thining about looking at jiffies value and stop once
it is startjiffy+2, but with NO_HZ introduction, are jiffies
still incremented ?
