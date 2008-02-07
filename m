Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYBGQhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYBGQhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbYBGQh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:37:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYBGQhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:37:25 -0500
Message-ID: <47AB3382.3030806@redhat.com>
Date: Thu, 07 Feb 2008 11:36:18 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, Grant Grundler <grundler@parisc-linux.org>,
       Loic Prylli <loic@myri.com>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
References: <20080114230448.GL9847@does.not.exist>	<20080115174643.GB28238@kroah.com>	<20080115175641.GE18741@parisc-linux.org>	<20080119165809.GB11553@colo.lackof.org>	<479E1FA6.1030708@redhat.com>	<20080128204431.GA15227@kroah.com>	<20080128223141.GA31101@parisc-linux.org>	<20080128225334.GD4720@kroah.com>	<20080129025615.GC20198@parisc-linux.org>	<20080129030340.GE20198@parisc-linux.org>	<86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>	<47AB299D.4000500@redhat.com> <20080207082827.2b4e6112@laptopd505.fenrus.org>
In-Reply-To: <20080207082827.2b4e6112@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 07 Feb 2008 10:54:05 -0500
> Tony Camuso <tcamuso@redhat.com> wrote:
> 
>> Matthew,
>>
>> Perhaps I missed it, but did you address Yinghai's concerns?
>>
>> Yinghai Lu wrote:
>>> On Jan 28, 2008 7:03 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>>>> -int pci_conf1_write(unsigned int seg, unsigned int bus,
>>>> +static int pci_conf1_write(unsigned int seg, unsigned int bus,
>>>>                            unsigned int devfn, int reg, int len,
>>>> u32 value)
>>> any reason to change pci_conf1_read/write to static?
>>>
> 
> nothing should use these directly. So static is the right answer ;)

Agreed. Thanks, Arjan.

Matthew,
What about the ATA_RAM addition to Kconfig? Was it accidental,
or intended? If intended, how is it related?
