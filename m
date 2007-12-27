Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbXL0WAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbXL0WAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 17:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXL0WA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 17:00:26 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:46916 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXL0WAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 17:00:25 -0500
X-Greylist: delayed 12510 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2007 17:00:25 EST
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: iaL9KxG65sFyH/NRHEm13ZpWIsASIz2sPdozvvFFdQCNetlf
Message-ID: <47742058.3070802@tragetaschen.dyndns.org>
Date: Thu, 27 Dec 2007 22:59:52 +0100
From: Kai Ruhnau <kai@tragetaschen.dyndns.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071122)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Loic Prylli <loic@myri.com>, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca> <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org> <477414C9.3040906@myri.com> <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 27 Dec 2007, Loic Prylli wrote:
>   
>> Does the 0001 vendor-id still shows up if pci_enable_crs() has never
>> been called?
>>     
>
> I don't believe we have ever tried, but it would be very interesting to 
> hear. 
>
> Kai, can you try that? Just remove the call to pci_enable_crs() in 
> pci_scan_bridge() in drivers/pci/probe.c, and see if mmconfig starts 
> working for you?
>   

Removing the call to pci_enable_crs() indeed solved it. I got the right
vendor IDs.

Kai

-- 
This signature is left as an exercise for the reader.

