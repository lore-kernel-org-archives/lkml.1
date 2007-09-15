Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbXIOOsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbXIOOsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbXIOOsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:48:05 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:47941 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbXIOOsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:48:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18155.61586.118828.112512@stoffel.org>
Date: Sat, 15 Sep 2007 10:47:46 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jon Ivar Rykkelid <jonry@pvv.org>
Cc: linux-kernel@vger.kernel.org, Prakash Punnoor <prakash@punnoor.de>,
       Robert Hancock <hancockr@shaw.ca>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: sata_nv issues with MCP51 SATA controller
In-Reply-To: <46EBB08A.5050709@pvv.org>
References: <46E8EABF.3060409@pvv.org>
	<46EA97F0.9000300@pvv.org>
	<46EAF099.9070805@pvv.org>
	<200709150912.28358.prakash@punnoor.de>
	<46EBB08A.5050709@pvv.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jon" == Jon Ivar Rykkelid <jonry@pvv.org> writes:

Jon> Prakash Punnoor wrote:
>> I don't have exaclty the same hw, but the same chipset and I don't have any 
>> problems - even with the swncq patch applied. Do you have an hpet? If not, 
>> try booting with acpi_use_time_override. My system won't work with skipping 
>> the override.

Jon> Hi , I reconnected and rebooted with the kernel option
Jon> "acpi_use_timer_override" (this is the correct spelling, isn't
Jon> it? - Kernel didn't complain.). Didn't help, the same error
Jon> received as before. - I'll have to connect all disks back to my
Jon> PCI-connected SATA controllers and start rebuilding my RAID yet
Jon> again.

What happens when you just have ONE disk connected to the motherboard
controller, and the rest connected to PCI controllers?  Does it crap
out then?  You've just such a nice repeatable problem across
motherboards that it's a shame to waste this debugging time.

I'm wondering if it's a PCI bus issue somehow, and that the load on
the motherboard controller isn't supportable when you have a bunch of
disks on PCI controllers as well.  Shot in the dark...

Thanks for all your hard work on this, I know how frustrating it is to
not have a stable system!

John
