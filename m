Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZGZAFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZGZAFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 20:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZGZAFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 20:05:34 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:36085 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbZGZAFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 20:05:33 -0400
Message-ID: <4A6B9DCB.1090001@orcon.net.nz>
Date: Sun, 26 Jul 2009 12:05:31 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       xorg@lists.freedesktop.org
Subject: Re: Kernel 2.6.30.1 Oops on Alpha Architecture when starting Xserver
References: <4A5DB243.2000100@orcon.net.nz>	 <21d7e9970907152016u3b213beet9090ee3b34f6d8b1@mail.gmail.com>	 <4A6ACE7C.9090409@orcon.net.nz> <21d7e9970907251554m18e4fca5p69b758e36fddc7d9@mail.gmail.com>
In-Reply-To: <21d7e9970907251554m18e4fca5p69b758e36fddc7d9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx6.orcon.net.nz on Sun, 26 Jul 2009 12:05:33 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Jul 26 12:05:33 2009
X-DSPAM-Confidence: 0.7621
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
>>>> The kernel oops is:
>>>>
>>>>         
>>> So its a machine check,
>>>
>>>       
>> So, does this indicate a software fault (e.g. inconsistencies in kernel data
>> structures) or does it imply a hardware fault?
>>
>>     
>>> Well X is trying to post the graphics card you have installed, and the
>>> machine
>>> is falling over when it does it.
>>>
>>>       
>> SRM (the equivalent of a BIOS) cannot post the card on startup.  But I have
>> had the card (radeon rv610) post correctly and working in the past when I
>> compiled the complete 1.5.3 Xserver myself.  I had it working with both the
>> radeon and radeonhd drivers and a 2.6.29.x kernel patched to support
>> libpciaccess.
>>     
>
> There is no -ati card in that machine, its got some SiS card which is
> completely
> different, maybe its some onboard card or something.
>   

No, you have misunderstood.   I removed that Radeon rv610 card (that 
caused the kernel oops) from the machine and replaced it with an old SiS 
card I have.  The behaviour changed: now the Xserver locks up on 
initialisation and consumes 100% CPU.  The backtrace I provided is with 
the SiS card only.  I thought it might be helpful to locate the problem 
(assuming that we are seeing a different symptom of the same underlying 
problem).

BTW, my attempt to CC the xorg mailing list failed.  It would seem that 
they are too exclusive to allow posting to their email list without 
subscription.  Putting up such barriers means they won't get bug reports 
from such people as myself.  Their loss.

Cheers
Michael

