Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZDXE5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZDXE5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZDXE5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:57:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38282 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZDXE5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:57:31 -0400
Message-ID: <49F146B1.5010500@jp.fujitsu.com>
Date: Fri, 24 Apr 2009 13:57:21 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 3/4] PCI: PCIE AER: PCIE AER software error injection
References: <1240541127.6842.681.camel@yhuang-dev.sh.intel.com>	 <49F140F7.4030705@jp.fujitsu.com> <1240547769.6842.782.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1240547769.6842.782.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Fri, 2009-04-24 at 12:32 +0800, Kenji Kaneshige wrote:
>> Huang Ying wrote:
>>> Debugging PCIE AER code can be very difficult because it is hard to
>>> trigger various real hardware errors. This patch provide a software
>>> based error injection tool, which can fake various PCIE errors with a
>>> user space helper tool named "aer-inject". Which can be gotten from:
>>>
>>>   http://www.kernel.org/pub/linux/kernel/people/yhuang/
>>>
>>> The patch fakes AER error by faking some PCIE AER related registers
>>> and an AER interrupt for specified the PCIE device.
>>>
>>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>>>
>>> ---
>>>  drivers/pci/pcie/aer/Kconfig       |    2 
>>>  drivers/pci/pcie/aer/Kconfig.debug |   18 +
>>>  drivers/pci/pcie/aer/Makefile      |    1 
>>>  drivers/pci/pcie/aer/aer_inject.c  |  472 +++++++++++++++++++++++++++++++++++++
>>>  4 files changed, 493 insertions(+)
>>>
>>> --- /dev/null
>>> +++ b/drivers/pci/pcie/aer/aer_inject.c
>>> @@ -0,0 +1,472 @@
>>> +/*
>>> + * PCIE AER software error injection support.
>>> + *
>>> + * Debuging PCIE AER code is quite difficult because it is hard to
>>> + * trigger various real hardware errors. Software based error
>>> + * injection can fake almost all kinds of errors with the help of a
>>> + * user space helper tool aer-inject, which can be gotten from:
>>> + *   http://www.kernel.org/pub/utils/pcie/aer-inject
>> Shouldn't it be 
>>
>> http://www.kernel.org/pub/linux/kernel/people/yhuang/
> 
> Yes. I forget to change this. But the directory to put aer-inject tar
> ball is subject to be changed. I am contacting with kernel.org ftp
> maintainer for appropriate place.
> 

I see.

By the way, thank you for this very nice feature!

Thanks,
Kenji Kaneshige


