Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYKEJUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYKEJUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYKEJUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:20:12 -0500
Received: from hs-out-0708.google.com ([64.233.178.245]:59344 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYKEJUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VeROcq5+78ME4Xl9Mfk7dA9hDHz9teQ5Zs5/atEBP/8mS39I8f+QFksG9jVE+E0O9G
         CB2AH8is8+p9ZnKykLpdppLQgWQk8AA8yFtIOKtiL7X1ZVygmwtjhv0Yi9rPH56eNgfi
         BstCg5vKHs/jsjPfVGwZdNFTPH8/nc3A6Xr0Q=
Message-ID: <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com>
Date: Wed, 5 Nov 2008 14:50:01 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: sharing interrupt between PCI device
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>
In-Reply-To: <49115AFC.2030400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
	 <4910E8AC.7050407@shaw.ca>
	 <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
	 <49115AFC.2030400@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


Code is here
first one USB Virual input devices

http://lxr.linux.no/linux+v2.6.27.4/drivers/usb/core/hcd-pci.c

Second one is hp-ilo driver

http://lxr.linux.no/linux+v2.6.27.4/drivers/misc/hpilo.c


Thanks
Nobin Mathew.


On Wed, Nov 5, 2008 at 2:06 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 11/05/2008 08:49 AM, Nobin Mathew wrote:
>> Hi
>>
>> This is the system information X86_64 platform Xeon dual core processor.
>>
>> I saw the pci_disable_device () it is calling pcibios_disable_device
>> () and this is is defined as
>>
>> void pcibios_disable_device (struct pci_dev *dev)
>> {
>>         pcibios_disable_resources(dev);
>>         if (pcibios_disable_irq)
>>                 pcibios_disable_irq(dev);
>> }
>>
>> In i386 platform, I could not find a definition for these calls in
>> x86_64 platform, i think it is using i386 platform code.
>
> Well, will you show us the code, so that we needn't to crystal gaze? It's pretty
> hard to say what happens, if we don't see what you do in the driver...
>
