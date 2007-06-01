Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbXFAU0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbXFAU0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762441AbXFAU0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:26:25 -0400
Received: from lucidpixels.com ([75.144.35.66]:33540 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762026AbXFAU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:26:24 -0400
Date: Fri, 1 Jun 2007 16:26:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Andi Kleen <andi@firstfloor.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't
 the kernel realize the BIOS has problems and re-map appropriately?
In-Reply-To: <20070601202416.GL7217@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0706011625130.7446@p34.internal.lan>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
 <200706011210.15808.jbarnes@virtuousgeek.org> <p73k5unbcnq.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0706011618270.7446@p34.internal.lan> <20070601202416.GL7217@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Andi Kleen wrote:

>> 1. The MCH/ICH8 hub 'requires' a minimum of 512MB to run, the board manual
>> states it needs at least 512MB of memort.
>> 2. The DVT/IGP graphics uses either 128MB or 256MB, I have it set to
>> 128MB.
>>
>> How can the Linux kernel find this out/poll this information so users do
>> not have to know mem=XXXXM?
>
> I don't think it should. The Linux kernel is not trying to be
> a BIOS replacement and should not know everything about the platforms
> it runs on.   We sometimes try to work around very common
> bugs, but this one (involving lots of memory and special configuration)
> seems to be more in the exotic range where command line options
> or waiting for a BIOS update seem better options.
>
> -Andi
>

4GB of memory is $150 these days and this is a very common board *965 
chipset, the bug occured with any bios > 1666P and 4GB of memory (or) 
version 1612P (and possibly others) with 8GB of memory.

I guess a warning in dmesg or such would be appropriate letting the user 
know of a possible work-around with the mem= option?

Justin.
