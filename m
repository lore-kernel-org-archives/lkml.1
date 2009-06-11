Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbZFKEXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbZFKEXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 00:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbZFKEXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 00:23:15 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:61816 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZFKEXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 00:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X5c0Zap/YFrmwFKewJmwD9TIHfJSbwBCSsaVIyhqif6VZ4BpNdT8EFyna5JVxcQpjl
         I5eveYdSqDVPaaMxAx58HhTVFknrlr+3hXovo8BmNUDI0FuN2tSYVj0+NX40+h7uDOC3
         BsdzoaTvdT1pMipizcFR+2tjnfqyY0LfVP4vg=
Message-ID: <4A3086B2.2010900@gmail.com>
Date: Wed, 10 Jun 2009 22:23:14 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Macbook 4G only see 3G
References: <9b1675090906101747u4ab8cc89t764ba80b4eb3dcb2@mail.gmail.com>	 <86802c440906101754g496da536t48ade9b1b220449a@mail.gmail.com> <9b1675090906101943x10dff40ak32341383a516ae7c@mail.gmail.com>
In-Reply-To: <9b1675090906101943x10dff40ak32341383a516ae7c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trenton D. Adams wrote:
> My dmesg is below.  Unfortunately, I will not be able to help with
> testing for a bit now.  I just got my memory today, and it's either
> bad, there's something wrong with the Macbook, or the memory doesn't
> work with the Macbook as Kingston claims it does.  So, I have to send
> it in for RMA I guess.
> 
> On Wed, Jun 10, 2009 at 6:54 PM, Yinghai Lu<yhlu.kernel@gmail.com> wrote:
>> On Wed, Jun 10, 2009 at 5:47 PM, Trenton D.
>> Adams<trenton.d.adams@gmail.com> wrote:
>>> Hi Guys,
>>>
>>> Has anyone been doing any development in the area of enabling 4G for
>>> any PC that doesn't have an option in the BIOS?  The Mac OS X sees the
>>> full 4G, but Linux does not.
>>>
>>> tdamac ~ # uname -a
>>> Linux tdamac 2.6.30-rc7-dirty #3 SMP Fri Jun 5 21:24:29 MDT 2009
>>> x86_64 Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux
>> boot log?
> 
> dmtdamac ~ # dmesg
> Linux version 2.6.30-rc7-dirty (root@tdamac) (gcc version 4.3.2
> (Gentoo 4.3.2-r3 p1.6, pie-10.1.5) ) #3 SMP Fri Jun 5 21:24:29 MDT
> 2009
> Command line: root=/dev/ram0 init=/linuxrc real_root=/dev/s/sys dolvm
> hung_task_show_state=1
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   Centaur CentaurHauls
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000be08c000 (usable)
>  BIOS-e820: 00000000be08c000 - 00000000be28d000 (ACPI NVS)
>  BIOS-e820: 00000000be28d000 - 00000000beebe000 (ACPI data)
>  BIOS-e820: 00000000beebe000 - 00000000beeef000 (ACPI NVS)
>  BIOS-e820: 00000000beeef000 - 00000000bef00000 (ACPI data)
>  BIOS-e820: 00000000bef00000 - 00000000c0000000 (reserved)
>  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
>  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)

The e820 map is the way that the BIOS tells us what memory is available. 
  Here it's only showing about 3040MB of usable memory, all below 4GB. 
The usual way that it should work with 4GB of RAM is that the portion of 
the  memory corresponding to the address space occupied for PCI devices, 
etc.  gets relocated above 4GB. However either the chipset in your 
machine doesn't support memory hole remapping, the BIOS doesn't bother 
to use it or it doesn't bother to tell Linux where it is..

Do you know if Mac OS X is actually use all 4GB, or is it doing the 
"well, we can see there's actually 4GB installed but we won't mention 
that we can't use it all" trick, like some Windows does?
