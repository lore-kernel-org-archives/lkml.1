Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbXEQXgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbXEQXgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbXEQXfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:35:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbXEQXfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:35:53 -0400
Message-ID: <464CE6B2.5090403@zytor.com>
Date: Thu, 17 May 2007 16:35:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Further update of the i386 boot documentation
References: <200705172250.l4HMol8f004870@tazenda.hos.anvin.org> <464CE105.7030808@goop.org> <464CE38B.8010802@zytor.com> <464CE5A4.3040106@goop.org>
In-Reply-To: <464CE5A4.3040106@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Given that we have already established littleendian byte order, it's the
>> same thing.
>>   
> 
> Well, not quite; mentioning the string form first creates an ambiguity. 
> I'd express as something like: ``The magic number is 0x53726448
> (implicitly, stored little-endian), which breaks down to the characters
> "HdrS".''

It does not create any ambiguity whatsoever.  The two are equivalent
forms, and either is authoritative.

>>>> +
>>>> +Field name:	version
>>>> +Type:		read
>>>> +Offset/size:	0x206/2
>>>> +Protocol:	2.00+
>>>> +
>>>> +  Contains the boot protocol version, e.g. 0x0204 for version 2.04.
>>>>   
>>>>       
>>> So the version is in BCD?
>>>     
>> Valid objection.  It probably should be considered as (major, minor)
>> bytes, but we haven't had any releases where it hasn't also been valid
>> BCD.  I would prefer separate bytes myself, so 2.10 = 0x20a instead of
>> 2.10 = 0x210.
> 
> OK.  So is the major or minor at the lower address?

Minor.  Littleendian.

> 0x00 or \0-terminated is idiomatic and unambigous.  Not a big deal
> either way.

Null-terminated is idiomatic and unambiguous.

	-hpa
