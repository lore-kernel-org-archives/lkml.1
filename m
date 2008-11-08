Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYKHJul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYKHJul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYKHJuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:50:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:23453 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYKHJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OdWSozbDMmqxOzh4JqmvYojmhSxDCG7qtB2AaRyyTRSEP/08JcRhqVTV89AqV02wCo
         KyvvTv93rcXKhzYozggSAt9PoP1jBXrl05p0yaeCRvCM0I538e0h4x4HTxy0K2zv+sb8
         7UcbV3rsI9kX3s6xe2C+bRA/7RWufN6Kj9V5M=
Message-ID: <491560C7.7050607@gmail.com>
Date: Sat, 08 Nov 2008 10:49:59 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Nobin Mathew <nobin.mathew@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sharing interrupt between PCI device
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no> <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com> <49115AFC.2030400@gmail.com> <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com> <20081108075729.GA15107@colo.lackof.org>
In-Reply-To: <20081108075729.GA15107@colo.lackof.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2008 08:57 AM, Grant Grundler wrote:
> On Wed, Nov 05, 2008 at 02:50:01PM +0530, Nobin Mathew wrote:
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
> 
> I looked for usage of request_irq() and didn't see it in either driver.

The second one doesn't use interrupts at all. How can this be listed in
/proc/interrupts on any line?

The first one obviously uses irq by registering it in common *hci layer.
