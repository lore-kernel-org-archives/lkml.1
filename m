Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbXEQXay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbXEQXay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbXEQXas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:30:48 -0400
Received: from gw.goop.org ([64.81.55.164]:49578 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbXEQXar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:30:47 -0400
Message-ID: <464CE5A4.3040106@goop.org>
Date: Thu, 17 May 2007 16:30:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Further update of the i386 boot documentation
References: <200705172250.l4HMol8f004870@tazenda.hos.anvin.org> <464CE105.7030808@goop.org> <464CE38B.8010802@zytor.com>
In-Reply-To: <464CE38B.8010802@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Given that we have already established littleendian byte order, it's the
> same thing.
>   

Well, not quite; mentioning the string form first creates an ambiguity. 
I'd express as something like: ``The magic number is 0x53726448
(implicitly, stored little-endian), which breaks down to the characters
"HdrS".''

>>> +
>>> +Field name:	version
>>> +Type:		read
>>> +Offset/size:	0x206/2
>>> +Protocol:	2.00+
>>> +
>>> +  Contains the boot protocol version, e.g. 0x0204 for version 2.04.
>>>   
>>>       
>> So the version is in BCD?
>>     
>
> Valid objection.  It probably should be considered as (major, minor)
> bytes, but we haven't had any releases where it hasn't also been valid
> BCD.  I would prefer separate bytes myself, so 2.10 = 0x20a instead of
> 2.10 = 0x210.
>   

OK.  So is the major or minor at the lower address?

>>> +Field name:	readmode_swtch
>>> +Type:		modify (optional)
>>> +Offset/size:	0x208/4
>>> +Protocol:	2.00+
>>> +
>>> +  Boot loader hook (see separate chapter.)
>>>   
>>>       
>> Chapter?  Is there a more specific reference you could make?
>>     
>
> Fair enough...
>
>   
>>> +Field name:	kernel_version
>>> +Type:		read
>>> +Offset/size:	0x20e/2
>>> +Protocol:	2.00+
>>> +
>>> +  If set to a nonzero value, contains a pointer to a null-terminated
>>>   
>>>       
>> "nil-terminated"? "\0-terminated"?
>>     
>
> Uh?  That seems more than a little silly.  Yes, I guess formally
> speaking we're talking about "NUL-terminated", but the term
> "null-terminated" has over 800,000 hits on Google -- 10 times as many as
> "NUL-terminated" -- and is hardly an ambiguous term ("NUL-terminated" is
> ugly, and "zero-terminated" is ambiguous.)
>   

0x00 or \0-terminated is idiomatic and unambigous.  Not a big deal
either way.

    J
