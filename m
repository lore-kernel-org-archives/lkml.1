Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbXL2Ufc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbXL2Ufc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 15:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXL2UfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 15:35:23 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:39960 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXL2UfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 15:35:22 -0500
Message-ID: <4776AF82.6010808@davidnewall.com>
Date: Sun, 30 Dec 2007 07:05:14 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: Mark Lord <lkml@rtr.ca>, Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org> <47760578.2090305@davidnewall.com> <alpine.DEB.0.999999.0712290754230.5207@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.0.999999.0712290754230.5207@twinlark.arctic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
>> Pffuff.  That's what volume managers are for!  You do have (at least) two
>> independent spindles in your RAID1 array, which give you less need to worry
>> about head-stack contention.
>>     
>
> this system is write intensive and writes go to all spindles, so you're
> assertion is wrong.

I don't know what you think I was asserting, but you were wrong.  Of 
course I/O is distributed across both spindles.  You would expect no 
less.  THAT is what I was telling you.

> the main worry i have is some user maliciously hardlinks everything
> under /var/log somewhere else and slowly fills up the file system with
> old rotated logs.  the users otherwise have quotas so they can't fill
> things up on their own.  i could probably set up XFS quota trees (aka
> "projects") but haven't gone to this effort yet.
>   

See, this is where you show that you don't understand the system.  I'll 
explain it, just once.  /var/home contains  home directories.  /var/log 
and /var/home are on the same filesystem.  So /var/log/* can be linked 
to /var/home/malicious, and that's just one of your basic misunderstandings.

>> LVM is your friend.
>>     
>
> i disagree.  but this is getting into personal taste -- i find volume
> managers to be an unnecessary layer of complexity.

Right... But wanting to change the semantics of link(2), so that you can 
do something that you already can do, anyway, this is simple, is it?

> you probably missed the point where i said that i was surprised i couldn't
> hardlink across the bind mount and actually wanted it to work.
>   

No.  Look, you obviously haven't read what I've told you.  I mean, it's 
very obvious you haven't.  I'm wasting my time on you and I'm now out of 
generosity.  Good luck to you.  I think you need it.

And no, you can't change link(2).  You don't need to.
