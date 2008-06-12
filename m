Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYFLV7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYFLV7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYFLV7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:59:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31278 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYFLV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Oxn3oaERFT5k2P2cV/pl4i0MJNBlu2YVVx11WIW4vzKlq7Gw4O4Gjz3d/XEZN31kVI
         qmwSuz/8bX3jkvBAB+v9FOJkaD7Qp58INcP3qoNkysIlHv66Nl19lNnP88WHWy7jj7YO
         KhfDSCoKZqAWrITs07zix3VXVLmfW4Dz9GWA8=
Message-ID: <48519BE6.5080107@gmail.com>
Date: Thu, 12 Jun 2008 23:57:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <200806121522.44199.bjorn.helgaas@hp.com> <48519782.9070306@gmail.com> <200806121557.28505.bjorn.helgaas@hp.com>
In-Reply-To: <200806121557.28505.bjorn.helgaas@hp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2008 11:57 PM, Bjorn Helgaas wrote:
> On Thursday 12 June 2008 03:39:14 pm Jiri Slaby wrote:
>> On 06/12/2008 11:22 PM, Bjorn Helgaas wrote:
>>> On Thursday 12 June 2008 03:10:04 pm Jiri Slaby wrote:
>>>> On 06/11/2008 09:03 PM, Bjorn Helgaas wrote:
>>>>> Before you go to all the trouble of bisecting it, can you turn on
>>>>> CONFIG_PNP_DEBUG and try the following debug patch?  I think this
>>>>> will prevent the oops, but it's just papering over the real problem,
>>>>> so please capture the complete dmesg log.
>>>> ACPI: PCI interrupt for device 0000:00:02.0 disabled
>>>> serial 00:07: disabled
>>>> serial 00:06: disabled
>>>> ACPI handle has no context!
>>>> ACPI: PCI interrupt for device 0000:00:1d.7 disabled
>>>> ...
>>>> serial 00:06:   no dma resource to encode!
>>>> serial 00:06: activated
>>>> serial 00:07:   no dma resource to encode!
>>>> serial 00:07: activated
>>>> ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
>>> Interesting.  I wonder why a serial device would have a DMA resource.
>>> We encode resources by following a template from _CRS, so evidently
>>> that template had a DMA resource.  Or something deeper is wrong.
>>>
>>> Can you send me the rest of that dmesg log?
>> Below.
> 
> Thanks, but it looks like CONFIG_PNP_DEBUG is not turned on.  Can
> you turn that on and capture the log again, please?

Sorry, too tired, so I overlooked it. Tomorrow. Thanks.
