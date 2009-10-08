Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbZJHVvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbZJHVvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbZJHVvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:51:52 -0400
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:50233 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbZJHVvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:51:51 -0400
Message-ID: <4ACE5ED2.2040106@gmail.com>
Date: Fri, 09 Oct 2009 00:51:14 +0300
From: Harri Olin <harri.olin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Bernie Innocenti <bernie@codewiz.org>
CC: Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>	 <4ACB3741.2030101@gmail.com>  <1254852272.1471.172.camel@giskard> <1255019160.30440.666.camel@giskard>
In-Reply-To: <1255019160.30440.666.camel@giskard>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
X-OriginalArrivalTime: 08 Oct 2009 21:51:04.0154 (UTC) FILETIME=[6ECE93A0:01CA4861]
X-CT-RefID: str=0001.0A0B0205.4ACE5EC9.011D,ss=1,fgs=0
Content-Transfer-Encoding: 8BIT
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernie Innocenti kirjoitti:
> El Tue, 06-10-2009 a las 14:04 -0400, Bernie Innocenti escribió:
>>> I have heard same thing happened with same kind of configuration, using 
>>> Supermicro H8DME-2 motherboard, Opteron 2378 CPU.
>>>
>>> Even the controllers were on same slots.
>> Close.  Mine is a Supermicro H8DM8-2 with 2x Opteron 2374 HE CPU.
> 
> I was wrong (the BIOS DMI block is wrong).  The motherboard is labeled
> as H8DME-2.
> 

H8DME-2 is the same board as H8DM8-2, just without scsi controller.

There is 2 3-pin jumpers somewhere between pci-x slots, one for each 
bus. With these you can force the bus to 66MHz PCI or 66MHz PCI-X. 
Without jumper means autodetect. Note that this information is only from 
manual, haven't been able to confirm what it really does :)

Oh and on the other identical case, I heard that moving other controller 
to different bus (1st controller in top slot and 2nd controller in 2nd 
slot from bottom) resolved the issue, or at least it has not error'd yet.

-- 
Harri.
