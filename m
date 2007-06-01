Return-Path: <linux-kernel-owner+w=401wt.eu-S1765118AbXFAU5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765118AbXFAU5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763658AbXFAU5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:57:18 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:52077 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763470AbXFAU5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:57:16 -0400
Date: Fri, 01 Jun 2007 14:56:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of RAM
 on Intel 965WH motherboards. (FULL DMESG)
In-reply-to: <Pine.LNX.4.64.0706011233100.18986@p34.internal.lan>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <46608816.9040607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com>
 <465E513E.60903@shaw.ca> <Pine.LNX.4.64.0706011233100.18986@p34.internal.lan>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
>> I think that mem=8832M would work as well, to make the kernel use only 
>> the memory that is marked cacheable. (It looks like this parameter 
>> takes the highest memory address we want the kernel to use, not the 
>> highest memory amount.)
>>
>> -- 
>> Robert Hancock      Saskatoon, SK, Canada
>> To email, remove "nospam" from hancockr@nospamshaw.ca
>> Home Page: http://www.roberthancock.com/
>>
> 
> Is 8832MB a typo?  8GB of memory is ~8192MB right?  Did you mean 8132MB 
> or?  Intel wants me to flash my bios and reset everything to the 
> defaults to see if it is still an issue, I'd prefer to try the mem= 
> option first.

I think 8832 should be right.. As far as I can tell, the number is the 
highest memory address, not the amount of memory, and there are some 
holes in the 3-4GB region.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


