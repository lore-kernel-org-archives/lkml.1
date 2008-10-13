Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYJMU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYJMU4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYJMU4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:56:06 -0400
Received: from 0x55512ece.adsl.cybercity.dk ([85.81.46.206]:26468 "EHLO
	sko.w0.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbYJMU4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:56:05 -0400
Date: Mon, 13 Oct 2008 22:56:00 +0200 (CEST)
From: Hans Schou <linux@schou.dk>
X-X-Sender: linux@sko.w0.dk
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
In-Reply-To: <87d4i5rq7i.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0810132240010.8901@sko.w0.dk>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> <87d4i5rq7i.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Andi Kleen wrote:

> Hans Schou <linux@schou.dk> writes:
>
>
>> flags           : fpu tsc cx8 mmx
>>
>> Instruction and data cache is 8KB each it says in the datasheet. I'm
>> not sure but it does not look like it is written in dmesg.
>>
>> ACPI sleep supports S1 S2 S3 S4 S5.
>>
>> CPU power states supports C0 C1 C2 C3.
>>
>> See attachment. (I hope it gets here!)
>
> Your attachment seems to be windows line end damaged.

Strange, Pine usually do it right with file attachments.
(what is "windows line end damaged"?)

> Also the changes are so small that it's not worth adding a CONFIG 
> for it. Just add it unconditionally.

I was not trying to invent anything. It is almost a copy of the UMC 
CPU, except that it is 586 code.

> And hardcoding the cache size for all of SiS seems a bit extreme. 
> What happens when SiS ever brings out another part with different 
> caches? Ideally figure out some way to detect this particular CPU 
> and only use 8 KB only for that. Alternatively ignore it (there's 
> nothing really in the kernel that uses the cache sizes anyways)

In that case the cache could be deleted.

One annoying thing is that the "model name" in /proc/cpuinfo is 
written as "00/55" instead of "SiS55x" when the CPU is not detected.

The worst problem is that an unknown CPU writes:
printk(KERN_ERR "CPU: Your system may be unstable.\n");
and the SiS55x is not unstable. Not until now at least and it has been 
on the market for 5 years.

Maybe the message could be changed to something less catastrophic when 
CPU is unknown.

So, many solutions could be be better than the one there is now.
And if the new solution will be usefull for other unknown CPU's it 
will be even better.

/hans
