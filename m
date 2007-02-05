Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbXBEFtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbXBEFtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXBEFtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:49:32 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:26126 "EHLO
	pd5mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbXBEFtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:49:31 -0500
Date: Sun, 04 Feb 2007 23:48:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
In-reply-to: <20070204213603.a5bce839.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>
Message-id: <45C6C531.20508@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <45C6BCE5.90103@shaw.ca>
 <20070204213603.a5bce839.akpm@linux-foundation.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 04 Feb 2007 23:13:09 -0600 Robert Hancock <hancockr@shaw.ca> wrote:
> 
>> Something's busted with forcedeth in 2.6.20-rc6-mm3 for me relative to 
>> 2.6.20-rc6. There's no errors in dmesg, but it seems no packets ever get 
>> received and so the machine can't get an IP address. I tried reverting 
>> all the -mm changes to drivers/net/forcedeth.c, which didn't help. The 
>> network controller shares an IRQ with the USB OHCI controller which is 
>> receiving interrupts, so it doesn't seem like an interrupt routing 
>> problem, though I suppose something wierd could be happening there.
>>
>> This is on an Asus A8N-SLI Deluxe (CK804 chipset) on x86_64.
>>
>> Any suggestions on how to debug/what to try reverting to see what's 
>> causing this?
> 
> There are many forcedeth changes in git-netdev-all.patch.  Can you
> try reverting drivers/net/forcedeth.c back to the unpatched version
> from 2.6.20-rc6?
> 
> Thanks.
> 

That's essentially what I did, it didn't appear to help. I assume the
problem must lie elsewhere..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

