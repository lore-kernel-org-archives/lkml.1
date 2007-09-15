Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbXIOTaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbXIOTaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbXIOTaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:30:05 -0400
Received: from ox.emgs.com ([194.248.190.99]:35394 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbXIOTaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:30:04 -0400
Message-ID: <46EC32B7.7010404@pvv.org>
Date: Sat, 15 Sep 2007 21:29:59 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: John Stoffel <john@stoffel.org>, Prakash Punnoor <prakash@punnoor.de>,
       Robert Hancock <hancockr@shaw.ca>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org>	<46EA97F0.9000300@pvv.org>	<46EAF099.9070805@pvv.org>	<200709150912.28358.prakash@punnoor.de>	<46EBB08A.5050709@pvv.org> <18155.61586.118828.112512@stoffel.org>
In-Reply-To: <18155.61586.118828.112512@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> What happens when you just have ONE disk connected to the motherboard
> controller, and the rest connected to PCI controllers?  Does it crap
> out then?  You've just such a nice repeatable problem across
> motherboards that it's a shame to waste this debugging time.
>   
Sorry, I gave in. I have now abandoned my nvidia trials (both 
motherboards have been returned, and I'm now running with Intel chipset) 
- My current motherboard is less ideal (in terms of PCI-slots etc.), but 
on the other hand it works...
> I'm wondering if it's a PCI bus issue somehow, and that the load on
> the motherboard controller isn't supportable when you have a bunch of
> disks on PCI controllers as well.  Shot in the dark...
>   
That was actually not such a bad idea... Unfortunately it's too late now 
(If not I should have tested for sure). I was/am after all running an 
8-disk SATA array (plus a normal IDE disk - not in the raid). I had 4 
disks running through two PCI-cards and 4 disks used the motherboard's 
controller. - When all 8 disks were connected to the two PCI-cards the 
speed dropped compared to when the motherboard's controller took some 
load.. (So it could maybe be an issue with bandwidth / load ? - I don't 
know.)
> Thanks for all your hard work on this, I know how frustrating it is to
> not have a stable system!
>   
Sorry for giving in, but I felt I was banging my head against the wall 
(and with too few sensible solutions being suggested). Now I guess I'm 
semi-happy that all seems to work OK with the Intel chipset.. 
Frustrating that the sata_nv-driver / nvidia HW didn't work with my 
configuration, though...

Thank you all for your effort as well - hope someone figures this out 
sometime in the future.

All the best
Jon Ivar
