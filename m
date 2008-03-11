Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYCKGvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYCKGvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYCKGvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:51:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYCKGvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:51:42 -0400
Message-ID: <47D6298C.3030105@zytor.com>
Date: Tue, 11 Mar 2008 07:41:16 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>
CC: Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, devzero@web.de,
       linux-kernel@vger.kernel.org, rick@vanrein.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
References: <182234194@web.de> <200803101523.03620.dl9pf@gmx.de> <47D56DD3.8060108@zytor.com> <200803110141.08863.dl9pf@gmx.de>
In-Reply-To: <200803110141.08863.dl9pf@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Simon Möller wrote:
> Am Montag 10 März 2008 18:20:19 schrieb H. Peter Anvin:
>> Jan-Simon Möller wrote:
>>> badram=0x18690000,0xffff0000
>>> (which means a whole from 0x18690000 to 0x1869ffff )
>> memmap=0x18690000$64K
>>
>> 	or
>>
>> memmap=0x18690000$0x10000
>>
>> 	-hpa
> 
> 
> Hmmm reading the kernel-parameters again and again ...
> 
> <QUOTE>
>         memmap=nn[KMG]$ss[KMG]
>                         [KNL,ACPI] Mark specific memory as reserved.
>                         Region of memory to be used, from ss to ss+nn.
> </QUOTE>
> 
> 
> nn would be 0x18690000   or ~409MB
> ss would be 0x10000      or 64k
> 
> quite big hole ???
> 
> I'm not in front of the faulty box, but something is wrong there ...
> 

Sorry, got it backwards.

	-hpa
