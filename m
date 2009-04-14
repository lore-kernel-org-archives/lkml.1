Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZDNRkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZDNRkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZDNRkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:40:08 -0400
Received: from rtr.ca ([76.10.145.34]:44470 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZDNRkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:40:07 -0400
Message-ID: <49E4CA75.902@rtr.ca>
Date: Tue, 14 Apr 2009 13:40:05 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at> <20090414172406.GX14687@one.firstfloor.org>
In-Reply-To: <20090414172406.GX14687@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Apr 14, 2009 at 06:33:50PM +0200, Anton Ertl wrote:
>> Andi Kleen wrote:
>>> "Anton Ertl" <anton@mips.complang.tuwien.ac.at> writes:
>>>> /dev/md2        /home           ext3    defaults,barrier=1      1	2
>>> Just make sure /dev/md2 is a RAID1, MD RAID0/5/10 don't support barriers.
>> Thank you.  I added the following to the README:
>>
>> |Note that, as of this writing (2009-04), not all Linux devices support
>> |barriers, in particular md devices only support them in RAID 1 mode;
>> |the kernel will reportedly warn about the lack of barriers if you try
>> |to use ext3 with barriers on a device that does not support barriers
>> |(look in, e.g., dmesg).
> 
> A full listing of what devices do and don't support barriers would
> be likely very long. You would actually need to list down to hard disks.
> 
> A common problem is barriers over LVM. Since 2.6.29 they work
> with a single device (and if the underlying device supports it) with 
> dm linear, but not in any other LVM setup.

..

Does anyone else here find this rather peculiar?

The folks who actually care about barriers the most
(apart from kernel developers) are probably enterprise users.

And who is most likely to be using RAID and LVM,
where barriers generally don't work at all ?

