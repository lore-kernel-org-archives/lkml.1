Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbXIOKOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbXIOKOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXIOKOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:14:39 -0400
Received: from ox.emgs.com ([194.248.190.99]:38158 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbXIOKOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:14:38 -0400
Message-ID: <46EBB08A.5050709@pvv.org>
Date: Sat, 15 Sep 2007 12:14:34 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Prakash Punnoor <prakash@punnoor.de>, Robert Hancock <hancockr@shaw.ca>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46EA97F0.9000300@pvv.org> <46EAF099.9070805@pvv.org> <200709150912.28358.prakash@punnoor.de>
In-Reply-To: <200709150912.28358.prakash@punnoor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prakash Punnoor wrote:
> I don't have exaclty the same hw, but the same chipset and I don't have any 
> problems - even with the swncq patch applied. Do you have an hpet? If not, 
> try booting with acpi_use_time_override. My system won't work with skipping 
> the override.
>
>   
Hi , I reconnected and rebooted with the kernel option 
"acpi_use_timer_override" (this is the correct spelling, isn't it? - 
Kernel didn't complain.). Didn't help, the same error received as 
before. - I'll have to connect all disks back to my PCI-connected SATA 
controllers and start rebuilding my RAID yet again.

It seems random which disk is first affected (This far, I know that it 
has happened to ata1, ata3 and ata4, three of my potential disks) - I 
guess it just happens to the disk that is being used at the moment when 
the driver / controller acts up.)

I'm about to give in. I think I'll try to replace both ( Gigabyte 
GA-N650SLI-DS4 ) motherboards, as the driver simply isn't working for 
the on-board controller of these boards. Could be a combination of the 
controllers and some other HW on the motherboards of course, but all is 
working when I connect all disks to my non-nvidia controllers. - Guess 
I'll opt for a motherboard with an intel-chipset after all...

BR
Jon Ivar
