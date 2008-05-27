Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbYE0KzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbYE0KzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 06:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYE0Ky4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 06:54:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53979 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbYE0Kyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 06:54:55 -0400
Message-ID: <483BE87B.3030703@garzik.org>
Date: Tue, 27 May 2008 06:54:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <483B2A9B.4050007@krogh.cc> <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org> <483B60DB.7020402@gmx.net> <483BE3FB.1010602@garzik.org> <483BE846.5090901@gmx.net>
In-Reply-To: <483BE846.5090901@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carl-Daniel Hailfinger wrote:
> On 27.05.2008 12:35, Jeff Garzik wrote:
>> Carl-Daniel Hailfinger wrote:
>>> New code should look like
>>> static struct pci_device_id ck804xrom_pci_tbl[] = {
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0051), .driver_data =
>>> DEV_CK804 },
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0360), .driver_data =
>>> DEV_MCP55 },
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0361), .driver_data =
>>> DEV_MCP55 },
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0362), .driver_data =
>>> DEV_MCP55 },
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0363), .driver_data =
>>> DEV_MCP55 },
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0364), .driver_data =
>>> DEV_MCP55 },
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0365), .driver_data =
>>> DEV_MCP55 },
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0366), .driver_data =
>>> DEV_MCP55 },
>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0367), .driver_data =
>>> DEV_MCP55 },
>>>     { 0, }
>>> };
>>
>> Actually, more like
>>
>>     { PCI_VDEVICE(NVIDIA, 0x0367), DEV_MCP55 },
> 
> AFAICS that would reintroduce the bug.

Look closely.

	Jeff




