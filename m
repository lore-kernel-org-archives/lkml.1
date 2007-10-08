Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXJHWgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXJHWgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbXJHWgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:36:23 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:38621 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXJHWgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:36:22 -0400
Message-ID: <470AB094.8010003@aitel.hist.no>
Date: Tue, 09 Oct 2007 00:35:00 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86-64 sporadic hang in 2.6.23rc7 and 2.6.22
References: <46F8273B.8030904@aitel.hist.no> <1190669351.4035.254.camel@chaos> <46FE5C98.1030507@aitel.hist.no> <alpine.LFD.0.9999.0709301755080.3142@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0709301755080.3142@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 29 Sep 2007, Helge Hafting wrote:
>   
>> Thomas Gleixner wrote:
>>     
>>>> I have gone back to 2.6.22rc4, which seems to work.
>>>>
>>>> This is a single opteron, although on a dual-slot board.
>>>>     
>>>>         
>>> Can you switch to serial console, so we can get some information out of
>>> that box? Sysrq-B is working, so we can get info from other sysrq
>>> functions as well.
>>>   
>>>       
>> I didn't need the serial - it crashes during console work too.
>> I think a "make clean" was in progress at the time. There must be work going
>> on in order to crash.
>>
>> This time 2.6.22rc4 died on me with a general protection fault
>>
>> I got two reports, the first one scrolled partially off screen but
>> the whole trace was there:
>>     
>
> That's why I asked for a serial console. That way we can get all the
> information from the reports including the register dumps ....
>   
I got another crash - with a full dump.  I have also discovered
files with lots of single-bit errors, so this is probably just some kind
of hw problem. :-(

Replace mermory or the motherboard with everything on it . . . :-(

Helge Hafting

