Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXEaNIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXEaNIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbXEaNIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:08:38 -0400
Received: from lucidpixels.com ([75.144.35.66]:51843 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXEaNIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:08:37 -0400
Date: Thu, 31 May 2007 09:08:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       crmotherboard@intel.com
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of
 RAM on Intel 965WH motherboards. (FULL DMESG)
In-Reply-To: <465EC464.7050302@gmail.com>
Message-ID: <Pine.LNX.4.64.0705310906590.6709@p34.internal.lan>
References: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com>
 <465E513E.60903@shaw.ca> <465EC464.7050302@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 May 2007, Parag Warudkar wrote:

> Robert Hancock wrote:
>> I think that mem=8832M would work as well, to make the kernel use only the 
>> memory that is marked cacheable. (It looks like this parameter takes the 
>> highest memory address we want the kernel to use, not the highest memory 
>> amount.)
>> 
> Yep, and that would be much easier too.
>
> I am curious though as this seems to be somewhat common a problem, could we 
> make the kernel analyze which memory is not cacheable (it already knows this 
> via MTRR) and not use that portion for anything? Plus may be warn the user to 
> contact their BIOS vendor to correct the problem?
>
> I think that would be possible - even if the kernel knows late that the 
> memory was uncached we could migrate those pages in that region to someplace 
> else?
>
> Parag
>

That is an excellent question and I wonder the same thing.  I also had 
this problem when I only used 4GB of ram and upgraded the (another 
motherboard, I have two) past version 1666P and I had no idea what was 
going on other than the BIOS did not work correctly.

In this case however it worked with 4GB with bios version 1612P but not 
with 8GB.  Is this the case of a buggy BIOS for the 965 chipset or do 
Intel boards have a lot of issues?

Justin.

