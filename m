Return-Path: <linux-kernel-owner+w=401wt.eu-S2992634AbXDLQUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992634AbXDLQUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992635AbXDLQUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:20:32 -0400
Received: from mta3.adelphia.net ([68.168.78.181]:45615 "EHLO
	mta3.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992634AbXDLQUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:20:31 -0400
Message-ID: <461E57E1.50201@acm.org>
Date: Thu, 12 Apr 2007 11:01:37 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Helge Hafting <helgehaf@aitel.hist.no>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri, can you send me the output of "lspci -x" ?

-corey

Jiri Kosina wrote:
> On Thu, 12 Apr 2007, Jiri Kosina wrote:
>
>   
>>> - try booting without any HID devices plugged in (i.e. usb mice, usb 
>>>   keyboards) if the problem persists?
>>> - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?
>>>       
>> Do you compile with CONFIG_HIDRAW?
>>     
>
> Helge,
>
> with your .config, my machine hangs upon IPMI initialization, the last 
> thing I see before total freeze is 
>
> ipmi_si: Trying PCI-specified kcs state machine at mem address 0xd0121000, slave address 0x0, irq 5
>
> (this was run on 32bit machine)
>
> When I turn IPMI off, I can't reproduce your hang, evetything runs 
> smoothly. Could you please try recompiling the kernel with IPMI disabled, 
> if it could be related?
>
> Corey added to CC.
>
> Thanks,
>
>   

