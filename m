Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYECTe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYECTe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYECTeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:34:17 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:37327 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYECTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:34:16 -0400
Date: Sat, 03 May 2008 13:34:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Remove Asus EEE UDMA/33 limitation.
In-reply-to: <fa.ulFofhLJhFFkP/xiWxdfjwM8XDA@ifi.uio.no>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Dave Jones <davej@codemonkey.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <481CBE36.6040007@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tsKjLRZd5ILFUSCwKgwjuJUvN+Y@ifi.uio.no>
 <fa.l6LkASoBXPmhrri16ok+xTRwEUY@ifi.uio.no>
 <fa.ulFofhLJhFFkP/xiWxdfjwM8XDA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sat, 3 May 2008 10:58:17 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
>> On Fri, May 02, 2008 at 11:44:58AM -0400, Dave Jones wrote:
>>
>>>  static const struct ich_laptop ich_laptop[] = {
>>>  	/* devid, subvendor, subdev */
>>> +	{ 0x2653, 0x1043, 0x82d8 },	/* ICH6M on Asus Eee PC */
>>>  	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
>>>  	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
>>>  	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
>> Don't the ACPI timing methods let us work this out without requiring 
>> machine specific knowledge? 
> 
> We don't currently sniff the ACPI timing data on Intel boxes - we can do
> so and there is a library routine but I'd be worried about the usual
> standard of BIOS code. Right now we only do it for chipsets which are so
> braindamaged we have no other choice or where the vendor specifically
> implemented and intended the ACPI data to be used for this (eg Nvidia)

Given that the bootup ACPI _GTM results will be used by Windows to 
determine the DMA mode setting with the standard Microsoft atapi.sys 
driver which PATA controllers would typically use, and Windows is what 
the majority of this hardware was designed to run, I think it should be 
quite trustworthy..
