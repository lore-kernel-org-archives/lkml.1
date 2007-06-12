Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbXFLMyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbXFLMyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXFLMyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:54:10 -0400
Received: from dedi.luli.de ([88.198.62.74]:59212 "EHLO dedi.luli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbXFLMyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:54:09 -0400
Message-ID: <466E976D.7060103@rootdir.de>
Date: Tue, 12 Jun 2007 14:54:05 +0200
From: Claas Langbehn <claas@rootdir.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
References: <466E65A7.3000206@msgid.tls.msk.ru> <5699f8f00706120344h40fe6f88vb7601c9326bd589f@mail.gmail.com> <466E8A5B.4080205@msgid.tls.msk.ru>
In-Reply-To: <466E8A5B.4080205@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote on LKML:
> Wander Winkelhorst wrote:
>   
>> On 6/12/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>     
>>> I bought a VIA PC2500 board a few days ago - this
>>> new series of their mobos,
>>>
>>> This beast looks nice - after replacing their cooling
>>> system (that had a small fan on it) with larger but
>>> fanless, -- it becomes a almost real PC (1500MHz CPU),
>>> equipped with quite nice crypto and multimedia abilities,
>>> but with very low power consumption and very quiet.
>>>
>>> But the thing is - it doesn't quite work.
>>>       
>> Try disabling CPU frequency scaling, VIA CPU's often have problems
>> with changing their frequency.
>>     
>
> Hmm.  I wonder how to *enable* it in the first place.. ;)
> e_powersaver.ko and acpi_cpufreq gives "No such device"
>
>   
cat /proc/cpuinfo and have a look at the flags. Does it support "eps"?

If not then e_powersaver is not possible. If cpufreq with acpi P-states
does not work either then your mainboard/CPU does not support
power saving.
You might get in contact with Rafal Bilinski who wrote e_powersaver.



claas
