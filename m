Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYBNSRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYBNSRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYBNSRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:17:40 -0500
Received: from mail.tmr.com ([64.65.253.246]:39732 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbYBNSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:17:39 -0500
Message-ID: <47B48564.1010709@tmr.com>
Date: Thu, 14 Feb 2008 13:16:04 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
References: <1201829922.23523.68.camel@brick>	<47B3AC24.5050605@tmr.com> <20080213185502.0005dd4d@extreme>
In-Reply-To: <20080213185502.0005dd4d@extreme>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
>>> Ping?
>>> What:   sk98lin network driver
>>> When:   Feburary 2008
>>> Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
>>> 	replaced by the skge driver. 
>>> Who:    Stephen Hemminger <shemminger@linux-foundation.org>
>>>
>>> ---------------------------
>>>       
>> We have been over this several times, and I thought someone had taken 
>> over the driver and was providing patches to put it in. Both skge and 
>> sky2 have been proposed as the replacement, people have reported 
>> problems with each. Suggest leaving this alone until the sk98lin 
>> actually needs work, then take it out. Problems in my problem system 
>> have been intermittent, take 4-40 hours to show and generate no errors, 
>> other than the driver thinks it's sending packets and the sniffer doesn't.
>>     
>
> The vendor sk98lin driver will continue it's happy life out of tree.
> The version in 2.6.25 is ancient and unmaintained and only supports older
> hardware. There are no outstanding issues with skge driver (sky2 is 
> prone to hardware problems, but then so is vendor driver).
>   

And those of us who are using it *have* old hardware. Old hardware that 
perhaps the people forcing other driver on us don't have.
> Unfortunately, removing sk98lin seems to be the only way to make die
> hard users report problems. The last time we removed it, some user's of
> old Genesis boards showed with issues, but those are now fixed.
>   

I guess I have a real problem with the "make die hard users report 
problems" thing, because it assumes that there is nothing wrong with 
*causing* us problems. Understand, this is not "change is bad" but 
"change is expensive." Because it means a change in kernel config, 
modules.conf, and possibly rc.local or initrd or similar. A per-machine 
effort which is small in ones, and large in sum.
> Jeff has scheduled sk98lin for removal in 2.6.26. (and it will probably 
> be gone from -mm before that). 
>
>   
If this were a case of the sk98lin driver needing work, I wouldn't be 
making the argument. But to make work for users in a case where there is 
no saving in effort for developers, sounds as if the developers place no 
value at all on the time of the people who build their own kernels, and 
if the vendors are good with it, that's all that matters.

Note that because the hardware is old, it's highly likely that most of 
it will be retired before that sk98lin driver needs a change. I can't 
see anyone using sk98lin on a new system, so it would be less 
contentious to let the hardware (or users) die of natural causes if you can.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


