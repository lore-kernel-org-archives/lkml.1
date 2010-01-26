Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831Ab0AZBd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab0AZBd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628Ab0AZBdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:33:55 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:39061 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab0AZBdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:33:55 -0500
Message-ID: <4B5E3E63.80305@blueyonder.co.uk>
Date: Tue, 26 Jan 2010 00:59:15 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: HDA Intel Audio hang on boot
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>	<4B4FC3B0.9070207@blueyonder.co.uk>	<4B5CF87A.20101@blueyonder.co.uk>	<201001252239.03017.rjw@sisk.pl>	<s5h8wblc0kw.wl%tiwai@suse.de> <s5h7hr5c0jn.wl%tiwai@suse.de>
In-Reply-To: <s5h7hr5c0jn.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/10 21:55, Takashi Iwai wrote:
> At Mon, 25 Jan 2010 22:54:23 +0100,
> I wrote:
>>
>> At Mon, 25 Jan 2010 22:39:02 +0100,
>> Rafael J. Wysocki wrote:
>>>
>>> On Monday 25 January 2010, Sid Boyce wrote:
>>>> On 15/01/10 01:24, Sid Boyce wrote:
>>>> This is the only outstanding bug. No problems up 2.6.32-git1, but I get
>>>> a solid lock-up on 2.6.32-git2 through 2.6.33-rc5 if the on-board audio
>>>> is not disabled in the BIOS.
>>>
>>> I guess we should let Takashi know.
>>
>> Thanks.
>>
>>>>> tindog:~ # uname -r
>>>>> 2.6.33-rc4-smp
>>>>> On 2.6.32-git1 which boots, hwinfo shows:-
>>>>>   oss.card_id = 'HDA NVidia'
>>>>>   oss.card_id = 'HDA NVidia'
>>>>>   oss.card_id = 'HDA NVidia'
>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>   info.product = 'HDA NVidia ALSA hardware specific Device'
>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>   info.product = 'HDA NVidia ALSA Control Device'
>>>>>   alsa.card_id = 'HDA NVidia'
>>>>>   info.product = 'HDA NVidia Sound Card'
>>>>>   sound.card_id = 'HDA NVidia'
>>>>>   info.linux.driver = 'HDA Intel'
>>>>>     22:     489835        578   IO-APIC-fasteoi   sata_nv, HDA Intel
>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
>>>>>        HDA Intel: module = snd_hda_intel
>>>>> irq:0 22 (   490413) "sata_nv" "HDA Intel"
>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
>>>>>        HDA Intel: module = snd_hda_intel
>>>>>        HDA Intel: /devices/pci0000:00/0000:00:0e.1
>>>>>        HDA Intel: module = snd_hda_intel
>>>>>   E: DRIVER=HDA Intel
>>>>>   <6>HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 22 (level,
>>>>> low) -> IRQ 22
>>>>>   <7>HDA Intel 0000:00:0e.1: setting latency timer to 64
>>>>>   Driver: "HDA Intel"
>>
>> What I'd try first is to pass enable_msi=0 option.
> 
> Just to be sure -- it's an option for snd-hda-intel module.
> 
> 
> Takashi
> 

I passed "modprobe snd-hda-intel enable_msi=0" on the kernel command
line, still locks up as before.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

