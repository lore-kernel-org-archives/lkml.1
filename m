Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbXCBBL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbXCBBL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXCBBL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:11:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46206 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964790AbXCBBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:11:28 -0500
Message-ID: <45E779BC.7020605@garzik.org>
Date: Thu, 01 Mar 2007 20:11:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andre Tomt <andre@tomt.net>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFT, v2] sata_mv: convert to new EH
References: <20070225233454.GA31282@havoc.gtf.org> <45E775DC.9080405@tomt.net>
In-Reply-To: <45E775DC.9080405@tomt.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Tomt wrote:
> Jeff Garzik wrote:
>> Just got sata_mv working under the new EH, on my 6041.
>>
>> It probes and talks to disks just fine (chip doesn't support ATAPI),
>> and hotplug actually has a chance of working.
>>
>> The 'mv-eh' branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git 
>> mv-eh
>>   
> 
> It's great to see this driver getting some more love. On a 6041 I'm 
> seeing very bad behaviour when encountering errors using the 2.6.19 
> driver. If a disk gets the fits, the port dies and 500000 interrupts/s 
> gets fired until the server gets rebooted. Good thing it only pegs one 
> of four available cpu cores.. I hope the new EH is more robust in this 
> regard ;-)

So, does this patch work for you?  :)  It's against 2.6.21-rc1 IIRC.


> Ramblings aside; I see there is a mv-ncq head in libata-dev.git, do you 
> have it working? Is there a timeframe for NCQ support?

No and no.  All this Marvell work is spare-time work for me, nobody's 
paying for it, so who knows.  I'll have it working eventually, if 
someone else doesn't beat me to it.

	Jeff



