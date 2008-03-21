Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYCULbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYCULbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYCULba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:31:30 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:36544 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbYCULb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:31:29 -0400
Date: Fri, 21 Mar 2008 07:31:06 -0400
From: "Peter F. Patel-Schneider" <pfps@verizon.net>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia,
 disabling IRQ #9 and Re: libata and legacy ide pcmcia failure
In-reply-to: <20080321104002.27a7d19e@core>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
Message-id: <47E39C7A.2090706@verizon.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <47067DB9.80200@roarinelk.homelinux.net>
 <47E300B2.7000104@verizon.net>	<20080321011205.4c7b4a61@core>
 <47E31197.70003@gmail.com> <20080321104002.27a7d19e@core>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 21 Mar 2008 10:38:31 +0900
> Tejun Heo <htejun@gmail.com> wrote:
>
>   
>> Alan Cox wrote:
>>     
>>> O> Mar 20 19:51:45 idefix kernel: ata12: PATA max PIO0 cmd 0xa100 ctl 
>>>       
>>>> 0xa10e irq 3
>>>> Mar 20 19:52:15 idefix kernel: ata12.00: qc timeout (cmd 0x91)
>>>> Mar 20 19:52:15 idefix kernel: ata12.00: failed to IDENTIFY 
>>>> (INIT_DEV_PARAMS failed, err_mask=0x4)
>>>>         
>>> Thinkpad T61p .. I've seen a few of these.
>>>
>>> Firstly try the card and adapter in a different PC and let me know if
>>> that works. So far they do. If that is the case get the latest firmware
>>> updates (BIOS etc) for your thinkpad and see if the problem goes away.
>>> They (or our ACPI code I guess it may be) have some serious IRQ routing
>>> problems on this box.
>>>       
>> Any chance the thing just chokes up on INIT_DEV_PARAMS?
>>     
>
> Possibly but I've seen several previosu reports showing no IRQ being
> delivered off these machines. You get IRQ 3 reported as assigned and an
> IRQ 9 turns up.
>
> Alan
>
>   

Also, these devices used to work about a year ago (same machine, earlier 
kernel) and then stopped working. 

It is entirely possible that some change triggered a BIOS(?) bug, or 
even that a BIOS upgrade caused the breakage, of course.

I'll try to try out the hardware in another Linux box - it may take a 
while, as I have to find out who at work has liberated their machine 
from corporate IT.  :-)

peter

