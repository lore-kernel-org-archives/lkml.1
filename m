Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZHSHuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZHSHuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZHSHuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:50:09 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:46359 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbZHSHuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:50:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-IronPort-AV: E=Sophos;i="4.43,407,1246831200";   d="scan'208";a="22953102"
Message-id: <4A8BAE8B.8080900@nets.rwth-aachen.de>
Date: Wed, 19 Aug 2009 09:49:31 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
To: "q-funk@iki.fi" <q-funk@iki.fi>
Cc: Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: x86 Geode issues in kernel >= 2.6.23 and >= 2.6.31-rc4
References: <11fae7c70908030558r28773beatd1dca702d490a57d@mail.gmail.com>
 <4A76E3E8.30902@nets.rwth-aachen.de>
 <11fae7c70908030624q11ffd29ened3c77ec4c4ca79a@mail.gmail.com>
 <4A76E6AA.2040608@nets.rwth-aachen.de>
 <11fae7c70908181147k4384478crc9909ec8256db868@mail.gmail.com>
In-reply-to: <11fae7c70908181147k4384478crc9909ec8256db868@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin-Éric Racine schrieb:
> On Mon, Aug 3, 2009 at 4:31 PM, Arnd
> Hannemann<hannemann@nets.rwth-aachen.de> wrote:
>> Martin-Éric Racine wrote:
>>> On Mon, Aug 3, 2009 at 4:19 PM, Arnd
>>> Hannemann<hannemann@nets.rwth-aachen.de> wrote:
>>>> Martin-Éric Racine wrote:
>>>>> (non-subscriber post; please keep me in CC)
>>>>>
>>>>> Greetings,
>>>>>
>>>>> Having previously reported two issues via Ubuntu's bug tracker and not
>>>>> found any answer, I thought I'd approach the LKML with the issues at
>>>>> stake.
>>>>>
>>>>> 1) Since kernel 2.6.23, one cannot boot hardware based on the Geode
>>>>> SCx200 series. Partial answers about the most plausible cause have
>>>>> been found by the target hardware's manufacturer as explained at
>>>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/241307
>>>>>
>>>>> 2) Since kernel 2.6.31-rc4, one cannot boot hardware based on the
>>>>> Geode LX800 as described at
>>>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/396286
>>>>>
>>>>> In case either of these issues was already reported and there is a
>>>>> know fix or work-around, I'd love to hear more. Otherwise, please feel
>>>>> free to contact me for additional details.
>>>>>
>>>> Just to give a data point:
>>>> 2.6.31-rc1,2,3,4,5 were/are running all fine on my Geode LX800
>>>> (http://www.pcengines.ch/alix2d2.htm) so it seems something
>>>> board or .config specific.
>>> Thank you for your answer, Arnd.
>>>
>>> Could you please send me a copy of your .config so that I can compare
>>> it with the one used on Ubuntu kernels?
>> Sure. Config for 2.6.31-rc5 is attached.
> 
> Could you try enabling CONFIG_FS_POSIX_ACL in your config and building
> a new kernel? Does it still boot?

Yes, still works.
However, I'm booting over PXE/NFS so it may not be used during boot.
I mounted an ext3 loop image when the machine was up, and that works.

Best regards,
Arnd

