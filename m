Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbXFFOgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbXFFOgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765808AbXFFOfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:35:50 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:55478 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765787AbXFFOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:35:48 -0400
Date: Wed, 06 Jun 2007 08:35:44 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.22-rc4-mm1
In-reply-to: <fa.zIhbKpmFY9tR8ro0OTwpTvD79Xk@ifi.uio.no>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <4666C640.5040408@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.463099pz3wyAW1RRKsHFuX299RE@ifi.uio.no>
 <fa.zIhbKpmFY9tR8ro0OTwpTvD79Xk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/ 
>>
>>
>>   
> 
> 
> Compile error here :
> 
> ..
> 
> LD .tmp_vmlinux1
> drivers/built-in.o: In function `acpi_init':
> bus.c:(.init.text+0x249a): undefined reference to `pci_mmcfg_late_init'
> make: *** [.tmp_vmlinux1] Error 1
> 
> ...
> 
> 
> http://frugalware.org/~crazy/other/mm/2.6.22-rc4-mm1/config
> 
> Regards,
> 
> Gabriel

Presumably because:

# CONFIG_PCI_GOMMCONFIG is not set

I'll cook up a patch later today.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

