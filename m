Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbYA2SNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbYA2SNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933698AbYA2SMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:12:00 -0500
Received: from rtr.ca ([76.10.145.34]:2880 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933690AbYA2SL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:11:57 -0500
Message-ID: <479F6C6B.7090505@rtr.ca>
Date: Tue, 29 Jan 2008 13:11:55 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: rgheck <rgheck@bobjweil.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Barkalow <barkalow@iabervon.org>,
       Gene Heskett <gene.heskett@gmail.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com>	<1201539043.31293.7.camel@zem>	<1201540830.6526.19.camel@localhost>	<200801281230.32910.gene.heskett@gmail.com>	<alpine.LNX.1.00.0801281248190.13593@iabervon.org>	<479E1D9E.3000900@bobjweil.com> <20080129121201.2f727f5f@core> <479F5D29.1020705@bobjweil.com>
In-Reply-To: <479F5D29.1020705@bobjweil.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rgheck wrote:
> Alan Cox wrote:
>>> not one problem but lots---is sufficiently widespread that a Mini 
>>> HOWTO, say, would be really welcome and, I'm guessing, widely used.
>>>     
>>
>> We don't see very many libata problems at the distro level and they for
>> the most part boil down to
>>
>> - sata_nv with >4GB of RAM, knowing being worked on, no old IDE driver
>> anyway
>>   
> Is this >4GB or >=4GB? I've seen contradictory reports, and I've got 4GB.
..

For all practical purposes, most memory over 3GB (or sometimes even 2GB)
on a 32-bit x86 system is treated as >4GB by the motherboard.

Because it's not the amount of *memory* that matters so much,
but rather the amount of *used address space*.  Video cards,
PCI devices, other motherboard resources etc.. can all subtract
from the available address space, leaving much less than 4GB
for your RAM. 

-ml

