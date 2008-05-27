Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYE0K6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYE0K6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 06:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYE0K6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 06:58:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:56699 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755697AbYE0K6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 06:58:36 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1+wCXcDgTywqe1LUVSzNsqqU5Zb4SkNAsnykeQfPh
	NXKuvDqfY7spNQ
Message-ID: <483BE958.10501@gmx.net>
Date: Tue, 27 May 2008 12:58:32 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080316 SUSE/1.1.9-1.1 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <483B2A9B.4050007@krogh.cc> <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org> <483B60DB.7020402@gmx.net> <483BE3FB.1010602@garzik.org> <483BE846.5090901@gmx.net> <483BE87B.3030703@garzik.org>
In-Reply-To: <483BE87B.3030703@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2008 12:54, Jeff Garzik wrote:
> Carl-Daniel Hailfinger wrote:
>> On 27.05.2008 12:35, Jeff Garzik wrote:
>>> Carl-Daniel Hailfinger wrote:
>>>> New code should look like
>>>> static struct pci_device_id ck804xrom_pci_tbl[] = {
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0051), .driver_data =
>>>> DEV_CK804 },
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0360), .driver_data =
>>>> DEV_MCP55 },
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0361), .driver_data =
>>>> DEV_MCP55 },
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0362), .driver_data =
>>>> DEV_MCP55 },
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0363), .driver_data =
>>>> DEV_MCP55 },
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0364), .driver_data =
>>>> DEV_MCP55 },
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0365), .driver_data =
>>>> DEV_MCP55 },
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0366), .driver_data =
>>>> DEV_MCP55 },
>>>>     { PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0367), .driver_data =
>>>> DEV_MCP55 },
>>>>     { 0, }
>>>> };
>>>
>>> Actually, more like
>>>
>>>     { PCI_VDEVICE(NVIDIA, 0x0367), DEV_MCP55 },
>>
>> AFAICS that would reintroduce the bug.
>
> Look closely.

My apologies. I missed the V in PCI_VDEVICE.

Regards,
Carl-Daniel
