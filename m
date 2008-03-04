Return-Path: <linux-kernel-owner+w=401wt.eu-S1765506AbYCDQbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765506AbYCDQbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764847AbYCDQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765203AbYCDQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:02 -0500
Message-ID: <47CD78F0.2060802@zytor.com>
Date: Tue, 04 Mar 2008 08:29:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rick van Rein <rick@vanrein.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
References: <20080302134221.GA25196@phantom.vanrein.org> <20080303082238.GB13580@elte.hu> <47CC3005.5090706@zytor.com> <20080304133028.GC32383@elte.hu>
In-Reply-To: <20080304133028.GC32383@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>
>> How is this different from:
>>
>> 	memmap=<size>$<len>
>>
>> ... ?
> 
> it's the inverse? When we identify bad areas of RAM, we really want to 
> "punch holes" into the existing memory map. So 'badram=' or 
> 'excludemem=' would be nicer and easier to use.
> 
> Or extend 'memmap=' with an inverse parameter: memmap=!0x10000000$1M 
> would exclude a 1MB region at 256MB physical.
> 

My understanding is that the $-form (as opposed to the @-form or #-form) 
is exactly that:

         memmap=nn[KMG]$ss[KMG]
                         [KNL,ACPI] Mark specific memory as reserved.
                         Region of memory to be used, from ss to ss+nn.

"Reserved" usually means "don't use as either memory or free address space".

	-hpa
