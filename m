Return-Path: <linux-kernel-owner+w=401wt.eu-S2992557AbXDTLwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992557AbXDTLwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992588AbXDTLwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:52:20 -0400
Received: from mtaout1.012.net.il ([84.95.2.1]:63398 "EHLO mtaout1.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992557AbXDTLwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:52:20 -0400
Date: Fri, 20 Apr 2007 14:52:18 +0300
From: Avi Kivity <avi@argo.co.il>
Subject: Re: VMWare Workstation 6 for debugging Linux Kernel (!)
In-reply-to: <1177069816.11136.21.camel@nigel.suspend2.net>
To: nigel@nigel.suspend2.net
Cc: Avi Kivity <avi@qumranet.com>, Andi Kleen <andi@firstfloor.org>,
       Xavier Bestel <xavier.bestel@free.fr>, roland <devzero@web.de>,
       linux-kernel@vger.kernel.org
Message-id: <4628A972.3090404@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Enigmail-Version: 0.94.3.0
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Fri,
 20 Apr 2007 14:52:18 +0300 (IDT)
References: <03f401c782d4$95c323e0$eeeea8c0@aldipc>
 <1177058522.14404.132.camel@frg-rhel40-em64t-04>
 <p73r6qf49zc.fsf@bingen.suse.de> <4628A7E3.5030908@qumranet.com>
 <1177069816.11136.21.camel@nigel.suspend2.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> Hi.
>
> On Fri, 2007-04-20 at 14:45 +0300, Avi Kivity wrote:
>   
>> Andi Kleen wrote:
>>     
>>> Xavier Bestel <xavier.bestel@free.fr> writes:
>>>
>>>   
>>>       
>>>> On Fri, 2007-04-20 at 00:46 +0200, roland wrote:
>>>>
>>>>     
>>>>         
>>>>> We just quietly added an exciting feature to Workstation 6.0. I believe it 
>>>>> will make WS6 a great tool for Linux kernel development. You can now debug 
>>>>> kernel of Linux VM with gdb running on the Host without changing anything in 
>>>>> the Guest VM. No kdb, no recompiling and no need for second machine. All you 
>>>>> need is a single line in VM's configuration file.
>>>>>       
>>>>>           
>>>> I think qemu has the exact same feature.
>>>>     
>>>>         
>>> It doesn't seem to work for x86-64 there though.
>>>   
>>>       
>> kvm's qemu has a patch that allows qemu to be an x86_64 gdbserver (with
>> or without kvm).
>>     
>
> I was meaning that vmware wasn't working, but it is now - I was trying a
> 64 host and client, and needed to know both the different line in the
> config file and the different port number.
>   

Andi was talking about qemu, not VMware, I believe.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

