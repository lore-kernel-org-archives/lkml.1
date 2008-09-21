Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbYIUTAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbYIUTAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYIUTAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:00:19 -0400
Received: from mail1.acecape.com ([66.114.74.12]:47902 "EHLO mail1.acecape.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYIUTAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:00:17 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Sep 2008 15:00:17 EDT
Message-ID: <48D697F5.9050802@acedsl.com>
Date: Sun, 21 Sep 2008 14:52:37 -0400
From: Wei Weng <wweng@acedsl.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
 restart.
References: <20080921172316.GA6306@2ka.mipt.ru>	<20080921110422.1d010b96@infradead.org>	<20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org>
In-Reply-To: <20080921113513.16677c4e@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 21 Sep 2008 22:28:38 +0400
> Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
>> On Sun, Sep 21, 2008 at 11:04:22AM -0700, Arjan van de Ven
>> (arjan@infradead.org) wrote:
>>> so now you go from an occasional burp to having nothing at all.
>>> How about you run with this patch on your own machine only?
>> And how else user can get attention to the problem which is not fixed
>> by the vendor? 
> 
> ... or the community
> 
>> We close our eyes and there is no problem, since we do
>> not see it. I just brought a lamp: no user can see that essentially
>> driver is broken so he can run it on his own risk.
>>
>>> or.. since you say a reload of the driver fixes it.. why don't you
>>> make a patch for the driver that does basically the actions of a
>>> reload automatically when the driver detects the issue?
>>> (and stick a WARN_ON in for good measure so that kerneloops.org can
>>> start tracking these burps)
>> It stops after several seconds (or packets?). Sometimes (but rarely)
>> it works several minutes, sometimes it fires above dmesg line and
>> continues to work, sometimes it fires it for a while and then stops
>> writing it, although driver does not send or receive anything (at
>> least ifconfig counters do not change).
> 
> again.. so how about you detect this condition and do, in the driver
> code, the equivalent of rmmod/insmod to the hardware. I'm sure people
> who have the hardware would appreciate that type of patch a lot more
> than the one you sent out.
> 

I guess it is your way of "middle finger" to all the IPW2100 customers who try
to use it on a Linux machine.


Thanks
Wei


