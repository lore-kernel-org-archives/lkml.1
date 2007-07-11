Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbXGKKBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbXGKKBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbXGKKAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:00:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbXGKKAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:00:53 -0400
Message-ID: <4694AA52.6040207@anagramm.de>
Date: Wed, 11 Jul 2007 12:00:50 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Nobin Mathew <nobin.mathew@gmail.com>,
       "vraghavan3@mail.gatech.edu" <vraghavan3@mail.gatech.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Reading a physical memory location
References: <1184010444.469290cce48df@webmail.mail.gatech.edu>	 <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>	 <1184091142.4693cc06850f7@webmail.mail.gatech.edu>	 <1a297b360707101502t2670f0d7g5197b9c32ecb967c@mail.gmail.com>	 <8d6898730707102243t60861fdar147f052501c31958@mail.gmail.com>	 <1a297b360707110111u25a786c5m4857673e3e1b90a1@mail.gmail.com>	 <8d6898730707110114p3c02e24as8ca8359731fdc320@mail.gmail.com> <1a297b360707110150x56e8ad6cu64ab768e7d3ce6ed@mail.gmail.com>
In-Reply-To: <1a297b360707110150x56e8ad6cu64ab768e7d3ce6ed@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/pB/xxVBsJ2buvd8fMAQrjZJqcP5e0jowpMRv
 9ZZ+5SwFI9bHrRAlFHQ0yM7HsIn45DynQqc8iKSUawDVeS8EIY
 Yr+ftYuPHt1FZkiGpaSaw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manu Abraham schrieb:
> On 7/11/07, Nobin Mathew <nobin.mathew@gmail.com> wrote:
>> See this in the documentation
>>
>> The returned virtual address is a current CPU mapping for the memory
>> address given. It is only valid to use this function on addresses that
>> have a kernel mapping
>>
>> This function does not handle bus mappings for DMA transfers. In
>> almost all conceivable cases a device driver should not be using this
>> function
>>
> 
> To get a better idea, look here
> http://tldp.org/LDP/khg/HyperNews/get/devices/addrxlate.html

Very nice! I have two more questions:

1. Is the document up to date?

2. Can anybody give an example how to "map" lots of pages (which
got filled by i.e. a scatter gather DMA chain) from a driver
(kernel space) to userspace?

Thanks
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
