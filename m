Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbZCBCON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbZCBCON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbZCBCNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:13:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:49718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321AbZCBCNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:13:41 -0500
Message-ID: <49AB4091.6060701@kernel.org>
Date: Sun, 01 Mar 2009 18:12:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: brk patches..
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>	 <1235785882-17580-4-git-send-email-jeremy@goop.org>	 <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>	 <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>	 <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org>	 <49A8F319.3030802@goop.org> <86802c440902281240i11423a95l98e330768ac6ca18@mail.gmail.com> <49AB1FE6.8030300@goop.org> <49AB3031.4020500@kernel.org> <49AB316E.4000009@zytor.com> <49AB3377.40904@goop.org> <49AB3805.6060109@zytor.com> <49AB3C70.7090701@goop.org>
In-Reply-To: <49AB3C70.7090701@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Jeremy Fitzhardinge wrote:
>>  
>>> (To be specific: I reshape the guest e820 table so that it doesn't have
>>> memory in any forbidden areas of the host e820 table.  That may require
>>> moving the pseudo-physical address of pages into a new overflow e820
>>> entry, which would also require allocating pages for the p2m radix
>>> tree.)
>>>
>>>     
>>
>> Isn't that the domain builder's job?
>>   
> 
> No.  It just provides a flat memory map from 0-max_pfn.  I want to avoid
> the overlap between pseudo-phys and machine memory so that the resource
> manager doesn't get confused by overlapping ranges, and so that it
> places the pci window in the same place as native.

where will those mem allocator needed?

if it is used after finish_e820_parsing(), you could use find_e820_area()

YH
