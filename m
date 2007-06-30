Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbXF3SZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbXF3SZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 14:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXF3SZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 14:25:05 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:22070 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbXF3SZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 14:25:03 -0400
Date: Sat, 30 Jun 2007 12:24:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel doesn't recognize complete memory
In-reply-to: <200706301946.46918.ffiene@veka.com>
To: Frank Fiene <ffiene@veka.com>
Cc: linux-kernel@vger.kernel.org, tytso@thunk.org
Message-id: <46869FF9.10909@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.8WY71RLqV3Tqf8TkTOMOg/ub4Cs@ifi.uio.no>
 <46859340.7020206@shaw.ca> <200706301946.46918.ffiene@veka.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Fiene wrote:
> On Samstag, 30. Juni 2007, Robert Hancock wrote:
>> Frank Fiene wrote:
>>> Lenovo Z61p, Intel Core2 Duo T7200
>>>
>>> I have 4GB RAM installed and BIOS recognize 4GB RAM.
>>> Linux kernel (Ubuntu-7.04, 32bit-PAE and 64bit, openSUSE-10.2
>>> 32bit-PAE and 64bit) tells me: only 3GB of RAM are installed.
>>>
>>> Any other user with a 4GB Thinkpad? tytso?
>>>
>>> What can i do? Please help!
>>>
>>> Regards
>>> Frank
>> Please post your bootup dmesg output. If your chipset doesn't support
>> memory remapping above 4GB or the BIOS doesn't enable it, you won't
>> be able to use all 4GB of memory.
> 
> Here is me dmesg output, fist 400 lines.

BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000bfed0000 (usable)
  BIOS-e820: 00000000bfed0000 - 00000000bfedf000 (ACPI data)
  BIOS-e820: 00000000bfedf000 - 00000000bff00000 (ACPI NVS)
  BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)

Yes, that's the problem. Your BIOS/chipset only provides about 3070MB of 
usable RAM to the OS. Unless there is a memory remap option in the BIOS 
that you can enable, there's not much you can do about it.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


