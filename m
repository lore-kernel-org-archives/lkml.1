Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbXLZPYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbXLZPYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 10:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXLZPYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 10:24:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:33851 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbXLZPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 10:24:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=xoOyLQgVVkDjgqX3fMuPNn2LLYW4Z/v9c/gEOrTtQ5bpvEdWYQZTWM15yVKs4bsienk+m8egZAEDAW+Ute6TH2iE6mhEM6S9Rvgl4jStaKOqJdllICr7LUqmpf2M6Sr49fKkP/4mRiNToANttXKQW/9k2q8UavMAlY9VMMsfNQw=
Message-ID: <47727216.4050003@gmail.com>
Date: Wed, 26 Dec 2007 18:24:06 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Suspend code ordering (again)
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712251713.13223.rjw@sisk.pl> <alpine.LFD.0.9999.0712252006330.21557@woody.linux-foundation.org> <200712261607.18429.rjw@sisk.pl>
In-Reply-To: <200712261607.18429.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 26 of December 2007, Linus Torvalds wrote:
>   
>> On Tue, 25 Dec 2007, Rafael J. Wysocki wrote:
>>     
>>> the ACPI specification between versions 1.0x and 2.0.  Namely, while ACPI
>>> 2.0 and later wants us to put devices into low power states before calling
>>> _PTS, ACPI 1.0x wants us to do that after calling _PTS.  Since we're following
>>> the 2.0 and later specifications right now, we're not doing the right thing for
>>> the (strictly) ACPI 1.0x-compliant systems.
>>>
>>> We ought to be able to fix things on the high level, by calling _PTS earlier on
>>> systems that claim to be ACPI 1.0x-compliant.  That will require us to modify
>>> the generic susped code quite a bit and will need to be tested for some time.
>>>       
>> That's insane. Are you really saying that ACPI wants totally different 
>> orderings for different versions of the spec?
>>     
>
> Yes, I am.
>
>   
>> And does Windows really do that?
>>     
>
> I don't know.
>   
Windows was compliant only with 1.x spec until Vista.
With Vista claims are 3.x compliance.

