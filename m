Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbXIYUpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbXIYUpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXIYUo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:44:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:10601 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbXIYUoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jxZC30F9OJzBKIZ3buCo1wL2EZLwD0fEyvUWh4IBfAsdgPqeAAueQYNyAy7aG8v4kMs4OKoAJgMbJjyNZD01x/WuzPWOQz9o4YgvaHEUQcsdqpjbgrhrdbhOjA88G5YnbeL3Jmn8A3Id8xFk4L+StZmgaMWvEqNlsqWxeFTo2VI=
Message-ID: <46F9733E.9080604@gmail.com>
Date: Tue, 25 Sep 2007 22:44:46 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: libata not working for sis5533
References: <46D132C5.5000803@gmail.com> <6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com> <46D8921E.3010304@gmail.com> <46D89429.7080802@gmail.com> <46E85AA8.3080302@redhat.com>
In-Reply-To: <46E85AA8.3080302@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert ha scritto:
> On 08/31/2007 06:20 PM, Patrizio Bassi wrote:
>   
>> Patrizio Bassi ha scritto:
>>     
>>> Michal Piotrowski ha scritto:
>>>       
>>>> Hi,
>>>>
>>>> [Adding IDE wizards to CC]
>>>>
>>>> On 26/08/07, Patrizio Bassi <patrizio.bassi@gmail.com> wrote:
>>>>   
>>>>         
>>>>> My sis630 chipset shipped with Asus A1000
>>>>> doesn't work properly with suspend with ide drivers
>>>>> (http://bugzilla.kernel.org/show_bug.cgi?id=7077)
>>>>>
>>>>> i tried to switch to libata but i cannot boot.
>>>>> I've enabled generic ide and sis specific code, both in-kernel. of
>>>>> course scsi too.
>>>>>
>>>>> when i boot i get: irq #14 nobody cared and stop
>>>>>
>>>>> i have to remove battery to reboot pc.
>>>>> I'm using 2.6.22.5, but i never got any libata kernel working.
>>>>>
>>>>> Patrizio
>>>>>
>>>>> ps. i'm writing from my desktop as i'm doing hardware mainteinance on
>>>>> the laptop and could not boot it
>>>>>
>>>>> Please CC me.
>>>>>
>>>>> lspci:
>>>>> 00:00.0 Host bridge: Silicon Integrated Systems [SiS] 630 Host (rev 11)
>>>>> 00:00.1 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev d0)
>>>>> 00:01.0 ISA bridge: Silicon Integrated Systems [SiS] SiS85C503/5513 (LPC
>>>>> Bridge)
>>>>> 00:01.1 Ethernet controller: Silicon Integrated Systems [SiS] SiS900
>>>>> PCI Fast Ethernet (rev 80)
>>>>> 00:01.2 USB Controller: Silicon Integrated Systems [SiS] USB  1.0
>>>>> Controller (rev 07)
>>>>> 00:01.3 USB Controller: Silicon Integrated Systems [SiS] USB 1.0
>>>>> Controller (rev 07)
>>>>> 00:01.4 Multimedia audio controller: Silicon Integrated Systems [SiS]
>>>>> SiS PCI Audio Accelerator (rev 01)
>>>>>  00:01.6 Modem: Silicon Integrated Systems [SiS] AC'97 Modem
>>>>> Controller (rev a0)
>>>>> 00:02.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual
>>>>> PCI-to-PCI bridge (AGP)
>>>>> 00:0a.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 80)
>>>>> 00:0a.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 80)
>>>>> 01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
>>>>> 630/730 PCI/AGP VGA Display Adapter (rev 11)
>>>>>     
>>>>>           
>>>> Regards,
>>>> Michal
>>>>
>>>>   
>>>>         
>> i've been out for a week, but found no notice, did i lost any email or
>> no activity on this issue?
>>
>>     
>
> I assume you tried the standard workarounds, like
>
>   pci=nommconf,nomsi
>   pci=noacpi
>   pci=biosirq
>
> (one at at time, not all at once.)
>
>
>   
i just fineshed to try (had an hardware problem, could not be faster)
but got no results :(

libata is unusable on my system.
i'll wait 2.6.23 to be out to try again.


-- 

Patrizio Bassi
www.patriziobassi.it
