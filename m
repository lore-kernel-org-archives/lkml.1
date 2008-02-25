Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbYBYX7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbYBYX7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYBYX7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:59:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:52105 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbYBYX7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=m8TxtVqmt3eYYWdMHr+AxTv2HMAXknMTHvQigDqgPTgTl41RjI0HKnNJbXZAz9Tk7Usoi9rnyo3gWrOe8RLpcSk+OmmTkcUeIteiuK4gANDyBgKg7K0qH2lTtiF2PFbOmF1MofrLPymf7iNrxG6hI6qIPV3tj4eR6Td+QW+rFF0=
Message-ID: <47C35661.80109@googlemail.com>
Date: Tue, 26 Feb 2008 00:59:29 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com> <47C344E5.5050205@linux.intel.com> <47C35046.8020007@googlemail.com>
In-Reply-To: <47C35046.8020007@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Arjan van de Ven wrote:
>> Gabriel C wrote:
>>> Arjan van de Ven wrote:
>>>> Gabriel C wrote:
>>>>> Laurent Riffard wrote:
>>>>>> Le 16.02.2008 09:25, Andrew Morton a écrit :
>>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
>>>>> [..]
>>>>>
>>>>> I'm getting that in mainline now on one of my older laptops also.
>>>> we fixed the cause of the machine you quoted; so I suspect yours is different..
>>>> Can you get me your stacktrace ? Can you try the patch from this thread to show
>>>> what memory the offender tries to access ?
>>> Arjan , sorry for the lag.
>>>
>>> With your patch from http://marc.info/?l=linux-kernel&m=120336371506283&w=2 I don't have a warning anymore.
>>>
>> that is ... odd since it's the same in theory, just with some added printk's ;-(
>>
> 
> hmm but in theory only that part of your patch only should do the same , no ?
> 
> 	if (page_is_ram(pfn)) {
> 		printk(..)
> 	}
> 
> I'm going to try that.
> 
> 

With only that part I get the waring again. 

But I see the printk() twice so I guess this should be in general an WARN_ON() ?

http://frugalware.org/~crazy/dmesg/dmesg_with_patch_2

 
