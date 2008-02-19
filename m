Return-Path: <linux-kernel-owner+w=401wt.eu-S1763311AbYBSXxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311AbYBSXxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbYBSXxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:53:36 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:16725 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbYBSXxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:53:35 -0500
Date: Tue, 19 Feb 2008 17:52:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Intel Core2Duo mobile - how does the VID get set?
In-reply-to: <fa.2QH6xosNob5B2/8HmS0yYeHCvG4@ifi.uio.no>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-id: <47BB6BD6.1090105@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.PElYyuLIylS1JDURm06DXLz2hAs@ifi.uio.no>
 <fa.pELF6tZ3LC4Qymp4Nyy0opWOQCE@ifi.uio.no>
 <fa.2QH6xosNob5B2/8HmS0yYeHCvG4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Morrison wrote:
> Pallipadi, Venkatesh wrote:
> 
>>> After a fair bit of Googling and reading around, I'm none the wiser 
>>> about exactly how Linux 2.6.x sets the processor VID (or for that 
>>> matter how it decides the FID settings) when using the ondemand 
>>> governor and cpufreq stuff.
>>>
>>> Can anyone tell me a) whether this is obtained from the BIOS, 
>>> something in the MSR of the processor or elsewhere and
>>
>> Yes. The freq and voltage supported comes from the platform BIOS. BIOS
>> exports this in an ACPI table which is handled by acpi-cpufreq driver in
>> Linux kernel.
>>
> 
> OK, thanks for that.
> 
>>  
>>> b) whether there is an interface in /proc or /sys where one can find 
>>> out what is set and modify it?
>>
>> There is no way of modifying and using new VIDs etc in Linux kernel
>> (other than exporting your own DSDT and hacking the related code).
> 
> Is there a way of viewing the ACPI table contents relating to the VIDs
> and FIDs?

Viewing the decompiled ACPI DSDT may provide some hints, however the 
kernel itself knows nothing about VID/FID settings for acpi-cpufreq, 
basically the kernel writes to magic ACPI registers and the BIOS or 
hardware take over to do what's required..
