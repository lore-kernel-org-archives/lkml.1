Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYBFV1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYBFV1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbYBFV1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:27:25 -0500
Received: from www17.your-server.de ([213.133.104.17]:57520 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbYBFV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:27:25 -0500
Message-ID: <47AA2634.7020907@m3y3r.de>
Date: Wed, 06 Feb 2008 22:27:16 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Latest kernel doesn't boot
References: <1202249704.47a8dfe89a99c@213.133.104.17> <47A8E427.6040205@zytor.com> <47AA1633.4000309@m3y3r.de> <47AA2082.4000402@zytor.com>
In-Reply-To: <47AA2082.4000402@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin schrieb:
> Thomas Meyer wrote:
>>
>> I can not revert the commit e429795c68d3001ecae74f6465420c9f043b0ece. 
>> it gave me errors.
>> but i'm also not sure what could be wrong with this commit!
>>
>> my first idea was that the commit 
>> "[2215e69d2cf5024647f9a034807990590d25dd4e] x86 boot: use E820 memory 
>> map on EFI 32 platform" is the offender, because the macbook pro 
>> doesn't provide a e820 memory map at all. but bisect showed that i'm 
>> wrong here?!
>>
>
> ELILO is expected to convert the memory map from EFI to e820 format.
I'm using elilo-3.6-ia32.efi provided at the elilo homepage.  i wasn't 
able to create a working efi toolchain :-(
Does elilo-3.6 already do the converting of the memory map, or not?
> EFI32 is likely to be poorly supported, since Apple is likely to be 
> the only platform to *ever* ship EFI32 in mass production, and it has 
> a BIOS emulation layer available.
What do you want so say? Does linux support EFI or not?
>
>     -hpa
>

mfg
thomas
