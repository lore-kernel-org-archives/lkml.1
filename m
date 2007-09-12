Return-Path: <linux-kernel-owner+w=401wt.eu-S1763812AbXILFVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763812AbXILFVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXILFVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:21:39 -0400
Received: from smtpauth14.prod.mesa1.secureserver.net ([64.202.165.39]:47537
	"HELO smtpauth14.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752289AbXILFVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:21:38 -0400
Message-ID: <46E7C49B.7030109@gmail.com>
Date: Wed, 12 Sep 2007 16:21:07 +0530
From: mkrameshid <mkrameshid@gmail.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Calling PnP bios routines like get device node from x86_84 arch
References: <12594726.post@talk.nabble.com>	<20070910173344.4bd2ae9e@the-village.bc.nu>	<46E675E6.1040105@gmail.com> <20070911105108.6d68a347@the-village.bc.nu>
In-Reply-To: <20070911105108.6d68a347@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

To be specific I want to call the function 0x60 ,0x61 and few more 
specified in the BBS specification (attached). These functions or alive 
in 16 bit mode (0xf000 segment)
We can call this functions in i386 using the pnpbios driver 
(bioscalls.c). I must call this functions to change the boot order and 
reboot from linux x86_64 using my driver.
I have seen in some forum that we can off the ACPI during the linux boot.

Can you help on this?

-mkr
Alan Cox wrote:
>> Actually I want to call the BIOS run time functions as per the 
>> PNPBIOSSpecification-v1.0a (attached).
>>     
>
> We use ACPI for x86_64, which means you need to use the ACPI methods not
> the PnPBIOS ones. PnPBIOS isn't valid when ACPI is in use.
>
> Alan
>
>   

