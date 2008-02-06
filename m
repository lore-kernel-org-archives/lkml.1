Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbYBFVpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbYBFVpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYBFVpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:45:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbYBFVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:45:42 -0500
Message-ID: <47AA2A75.80909@zytor.com>
Date: Wed, 06 Feb 2008 13:45:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: Latest kernel doesn't boot
References: <1202249704.47a8dfe89a99c@213.133.104.17> <47A8E427.6040205@zytor.com> <47AA1633.4000309@m3y3r.de> <47AA2082.4000402@zytor.com> <47AA2634.7020907@m3y3r.de>
In-Reply-To: <47AA2634.7020907@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> H. Peter Anvin schrieb:
>> Thomas Meyer wrote:
>>>
>>> I can not revert the commit e429795c68d3001ecae74f6465420c9f043b0ece. 
>>> it gave me errors.
>>> but i'm also not sure what could be wrong with this commit!
>>>
>>> my first idea was that the commit 
>>> "[2215e69d2cf5024647f9a034807990590d25dd4e] x86 boot: use E820 memory 
>>> map on EFI 32 platform" is the offender, because the macbook pro 
>>> doesn't provide a e820 memory map at all. but bisect showed that i'm 
>>> wrong here?!
>>>
>>
>> ELILO is expected to convert the memory map from EFI to e820 format.
> I'm using elilo-3.6-ia32.efi provided at the elilo homepage.  i wasn't 
> able to create a working efi toolchain :-(
> Does elilo-3.6 already do the converting of the memory map, or not?

Don't know.

>> EFI32 is likely to be poorly supported, since Apple is likely to be 
>> the only platform to *ever* ship EFI32 in mass production, and it has 
>> a BIOS emulation layer available.
> What do you want so say? Does linux support EFI or not?

I'm saying that in my opinion support for EFI32 is likely to be 
unreliable and never make it out of "experimental" status.  EFI is 
enough of a heap of junk on the 64-bit side.

Ying, do you have any insights?

	-hpa
