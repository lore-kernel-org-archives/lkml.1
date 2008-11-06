Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYKFHpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYKFHpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYKFHoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:44:38 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:46070 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbYKFHoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TMuqUZhX8gSWl0ze4UI5UQnYXV76PyTU9hA5FRpI2YdoE4/nBQ29c7Qlqxe/bVAx0+
         pKn24J/ogvfw6Lk6UqUI+Lt4emRO7XOkmIFTTnstf9p+UwBHFUbldY+jDFYD6YjAgmWp
         NpQEgCVpk97vmTjEf/dZ4pmTrsr58YafbxdPU=
Message-ID: <8d6898730811052344q218fc450i8c36fcd9e119d060@mail.gmail.com>
Date: Thu, 6 Nov 2008 13:14:32 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: sharing interrupt between PCI device
Cc: linux-pci@vger.kernel.org, "Robert Hancock" <hancockr@shaw.ca>,
       "Jiri Slaby" <jirislaby@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <8d6898730811052211k695d208r53609701af633c2d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
	 <4910E8AC.7050407@shaw.ca>
	 <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
	 <49115AFC.2030400@gmail.com>
	 <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com>
	 <8d6898730811052211k695d208r53609701af633c2d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

can anybody point to some reference device drivers where PCI interrupt
sharing is implemented properly.

Thanks
Nobin Mathew

On Thu, Nov 6, 2008 at 11:41 AM, Nobin Mathew <nobin.mathew@gmail.com> wrote:
> Hi
>
> Can somebody tell me what is going wrong in the driver. If you need
> any further information please tell me
>
> Thanks
> Nobin Mathew
>
> On Wed, Nov 5, 2008 at 2:50 PM, Nobin Mathew <nobin.mathew@gmail.com> wrote:
>> Hi
>>
>>
>> Code is here
>> first one USB Virual input devices
>>
>> http://lxr.linux.no/linux+v2.6.27.4/drivers/usb/core/hcd-pci.c
>>
>> Second one is hp-ilo driver
>>
>> http://lxr.linux.no/linux+v2.6.27.4/drivers/misc/hpilo.c
>>
>>
>> Thanks
>> Nobin Mathew.
>>
>>
>> On Wed, Nov 5, 2008 at 2:06 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>> On 11/05/2008 08:49 AM, Nobin Mathew wrote:
>>>> Hi
>>>>
>>>> This is the system information X86_64 platform Xeon dual core processor.
>>>>
>>>> I saw the pci_disable_device () it is calling pcibios_disable_device
>>>> () and this is is defined as
>>>>
>>>> void pcibios_disable_device (struct pci_dev *dev)
>>>> {
>>>>         pcibios_disable_resources(dev);
>>>>         if (pcibios_disable_irq)
>>>>                 pcibios_disable_irq(dev);
>>>> }
>>>>
>>>> In i386 platform, I could not find a definition for these calls in
>>>> x86_64 platform, i think it is using i386 platform code.
>>>
>>> Well, will you show us the code, so that we needn't to crystal gaze? It's pretty
>>> hard to say what happens, if we don't see what you do in the driver...
>>>
>>
>
