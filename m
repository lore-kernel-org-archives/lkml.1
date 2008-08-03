Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYHCLyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYHCLyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 07:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYHCLyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 07:54:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:56036 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbYHCLyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 07:54:07 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH 2/5] x86: Coding style fixes to arch/x86/kernel/bios_uv.c
References: <20080802212406.047e8ae6@paolo-desktop> <48952DB3.20101@zytor.com>
	<48958DC2.7070506@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 03 Aug 2008 13:54:03 +0200
In-Reply-To: <48958DC2.7070506@s5r6.in-berlin.de> (Stefan Richter's message of "Sun\, 03 Aug 2008 12\:51\:46 +0200")
Message-ID: <m3iquigvqc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

>>>      const char *str;
>>>      switch (status) {
>>> -    case  0: str = "Call completed without error"; break;
>>> -    case -1: str = "Not implemented"; break;
>>> -    case -2: str = "Invalid argument"; break;
>>> -    case -3: str = "Call completed with error"; break;
>>> -    default: str = "Unknown BIOS status code"; break;
>>> +    case  0:
>>> +        str = "Call completed without error";
>>> +        break;
>>> +    case -1:
>>> +        str = "Not implemented";
>>> +        break;
>>> +    case -2:
>>> +        str = "Invalid argument";
>>> +        break;
>>> +    case -3:
>>> +        str = "Call completed with error";
>>> +        break;
>>> +    default:
>>> +        str = "Unknown BIOS status code";
>>> +        break;
>>>      }
>>>      return str;
>>>  }
>>
>> This should be an array in the first place...
>
> Besides, by following CodingStyle to the letter, it arguably breaks
> rather than fixes coding style.  The former code was easy enough to
> read.

Right. The latter is much worse. That's why nobody can trust
CodingStyle and/or checkpatch automatically. It's only sane mode
of operation is as a help tool for authors and maintainers, to
quickly locate _potential_ problems.
-- 
Krzysztof Halasa
