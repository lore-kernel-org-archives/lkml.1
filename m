Return-Path: <linux-kernel-owner+w=401wt.eu-S1765010AbXFFSSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765010AbXFFSSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXFFSSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:18:45 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3340 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXFFSSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:18:45 -0400
Message-ID: <4666FA92.202@shadowen.org>
Date: Wed, 06 Jun 2007 19:18:58 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <fa.463099pz3wyAW1RRKsHFuX299RE@ifi.uio.no> <fa.zIhbKpmFY9tR8ro0OTwpTvD79Xk@ifi.uio.no> <4666C640.5040408@shaw.ca>
In-Reply-To: <4666C640.5040408@shaw.ca>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Gabriel C wrote:
>> Andrew Morton wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>>>
>>>
>>>   
>>
>>
>> Compile error here :
>>
>> ..
>>
>> LD .tmp_vmlinux1
>> drivers/built-in.o: In function `acpi_init':
>> bus.c:(.init.text+0x249a): undefined reference to `pci_mmcfg_late_init'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> ...
>>
>>
>> http://frugalware.org/~crazy/other/mm/2.6.22-rc4-mm1/config
>>
>> Regards,
>>
>> Gabriel
> 
> Presumably because:
> 
> # CONFIG_PCI_GOMMCONFIG is not set
> 
> I'll cook up a patch later today.

This one is affecting machines in TKO noce that the e820 problem is fixed.

-apw
