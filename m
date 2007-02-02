Return-Path: <linux-kernel-owner+w=401wt.eu-S1161126AbXBBNka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161126AbXBBNka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 08:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161131AbXBBNk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 08:40:29 -0500
Received: from poczta.o2.pl ([193.17.41.142]:49541 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161126AbXBBNk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 08:40:27 -0500
Date: Fri, 2 Feb 2007 14:43:11 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Fagyal Csongor <concept@conceptonline.hu>
Cc: Thomas Glanzmann <thomas@glanzmann.de>, Julien BLACHE <jb@jblache.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sky2 hangs
Message-ID: <20070202134311.GA1643@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C32654.3060602@conceptonline.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-02-2007 12:53, Fagyal Csongor wrote:
> Thomas Glanzmann wrote:
...
>>> Next time sky2 hangs on me I'll try to reset the PHY and see if that
>>> helps. I can usually trigger the hang by doing a couple of ifconfig
>>> up/down on the interface, though I'm not getting any error message
>>> from the driver when that happens.
>>>   
>>
>> same for me. In dmesg is absolut nothing. I change my fix script, too.
>> To see if that is enough to resolv the problem.
>>  
>>
> Well, ethtool -r eth0 did not work for me. :(
> 
> This time I got nothing in the log.
> 
> When I say ethtool -r eth0, I have this:
> sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
> 
> But the interface stays down. (Maybe the other end got confused?)

Hi,

Is this with this yesterday sky2-tx-recover.patch applied?

Jarek P.
