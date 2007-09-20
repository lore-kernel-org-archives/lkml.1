Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbXITGni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbXITGni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXITGnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:43:32 -0400
Received: from smtp1.Vir.com ([199.202.113.40]:35731 "EHLO smtp1.vir.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXITGnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:43:31 -0400
Message-ID: <46F21692.4020607@soo.com>
Date: Thu, 20 Sep 2007 02:43:30 -0400
From: ben soo <lnx-kern@soo.com>
Reply-To: lnx-kern@soo.com
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Network sky2 Module
References: <46E2BC6A.4070800@gmx.de>	<46EF4DE1.4000707@soo.com>	<46EFE09B.6090901@tmr.com> <20070918080525.7a49d110@freepuppy.rosehill.hemminger.net>
In-Reply-To: <20070918080525.7a49d110@freepuppy.rosehill.hemminger.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> ben soo wrote:
[...]
>>> This last might be an artifact caused by the firewall, i dunno.
[...]

> Bill Davidsen <davidsen@tmr.com> wrote:
>> Yes, I have found that I get far less problem in this area leaving the 
>> MTU at 1500, then putting a larger MTU (usually 9000) into the routing 
>> table for segments, or even just machines, where I know there is direct 
>> connectivity.
[...]

Stephen Hemminger wrote:
> If you want to use Jumbo frames, you need to have routers and firewalls
> that correctly handle ICMP and do path MTU discovery. If you have bridges
> or firewalls that aren't Jumbo aware on both interfaces, then there will
> be long timeouts retries for each connection. If you have busted routers
> and firewalls that swallow ICMP then PMTU won't work well either.

i turned off the motherboard Marvell Gbit devices and installed a 
Realtek 8169 card, all the while keeping to kernel version 
2.6.23-rc6, and saw all the network problems go away.  Must mean it 
was a sky2 driver bug.

Am currently running 2.6.23-rc7 on the affected server and the rc7 
sky2 driver is holding up fine so far.

thank you!

b
