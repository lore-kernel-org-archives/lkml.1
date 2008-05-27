Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYE0BXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYE0BXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 21:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYE0BXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 21:23:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:45861 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754266AbYE0BXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 21:23:23 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1/ENe5nB7LEcaHLUGQSrEdiMh7zk9j+ZJhIXU/EKp
	47r4su2TtlmW97
Message-ID: <483B6287.2000202@gmx.net>
Date: Tue, 27 May 2008 03:23:19 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080316 SUSE/1.1.9-1.1 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <483B2A9B.4050007@krogh.cc> <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org> <483B60DB.7020402@gmx.net>
In-Reply-To: <483B60DB.7020402@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2008 03:16, Carl-Daniel Hailfinger wrote:
> DEV_CK804 and DEV_MCP55 actually end up in class instead of driver_data.
>
> I'd send a patch, but I'm traveling and my only code access is gitweb.
>
> New code should look like
> static struct pci_device_id ck804xrom_pci_tbl[] = {
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0051), .driver_data = DEV_CK804 },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0360), .driver_data = DEV_MCP55 },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0361), .driver_data = DEV_MCP55 },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0362), .driver_data = DEV_MCP55 },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0363), .driver_data = DEV_MCP55 },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0364), .driver_data = DEV_MCP55 },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0365), .driver_data = DEV_MCP55 },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0366), .driver_data = DEV_MCP55 },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0367), .driver_data = DEV_MCP55 },
> 	{ 0, }
> };
>   

The change is
Signed-off-by: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
in case someone makes a patch from it.

Regards,
Carl-Daniel
