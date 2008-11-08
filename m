Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYKHLxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYKHLxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYKHLx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:53:29 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:45178 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYKHLx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:53:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W9W76wm7tCluunWnCvoZvV9BHwwZhRmT0BjZk8QUGKbiP8AguJO9HdNDXM3D8YZySE
         kPZRShDFubawT2xb6xkAkUrdz5T9Oyv9NbfPbIdkBSjvEn8nE8j/yE6R8VnCwO0MGj+E
         gj5r/8md67853cYa8EaRQZkS0cm6yoeW3JR9Q=
Message-ID: <8d6898730811080353q6cae6620qbf203735d592a40e@mail.gmail.com>
Date: Sat, 8 Nov 2008 17:23:25 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: sharing interrupt between PCI device
Cc: "Grant Grundler" <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, "Robert Hancock" <hancockr@shaw.ca>
In-Reply-To: <491560C7.7050607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
	 <4910E8AC.7050407@shaw.ca>
	 <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
	 <49115AFC.2030400@gmail.com>
	 <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com>
	 <20081108075729.GA15107@colo.lackof.org> <491560C7.7050607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what happens when we insert and remove the hp-ilo driver (dmesg logs).

for remove
ACPI: PCI interrupt for device 0000:01:04.2 disabled


when inserted
PCI: Enabling device 0000:01:04.2 (0114 -> 0117)
ACPI: PCI Interrupt 0000:01:04.2[B] -> GSI 23 (level, low) -> IRQ 225

Thanks

On Sat, Nov 8, 2008 at 3:19 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 11/08/2008 08:57 AM, Grant Grundler wrote:
>> On Wed, Nov 05, 2008 at 02:50:01PM +0530, Nobin Mathew wrote:
>>> Hi
>>>
>>>
>>> Code is here
>>> first one USB Virual input devices
>>>
>>> http://lxr.linux.no/linux+v2.6.27.4/drivers/usb/core/hcd-pci.c
>>>
>>> Second one is hp-ilo driver
>>>
>>> http://lxr.linux.no/linux+v2.6.27.4/drivers/misc/hpilo.c
>>
>> I looked for usage of request_irq() and didn't see it in either driver.
>
> The second one doesn't use interrupts at all. How can this be listed in
> /proc/interrupts on any line?
>
> The first one obviously uses irq by registering it in common *hci layer.
>
