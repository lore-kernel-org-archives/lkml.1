Return-Path: <linux-kernel-owner+w=401wt.eu-S965746AbXDBTfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965746AbXDBTfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXDBTfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:35:33 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:38686 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965746AbXDBTfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:35:32 -0400
Date: Mon, 02 Apr 2007 15:35:17 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: mmap error?
In-reply-to: <8EF5AE61-FC1C-4BA2-BB8D-B55221D8846B@mac.com>
To: linux-kernel@vger.kernel.org
Cc: Kyle Moffett <mrmacman_g4@mac.com>
Message-id: <200704021535.17567.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704021030.29747.gene.heskett@gmail.com>
 <200704021354.32636.gene.heskett@gmail.com>
 <8EF5AE61-FC1C-4BA2-BB8D-B55221D8846B@mac.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007, Kyle Moffett wrote:
>On Apr 02, 2007, at 13:54:28, Gene Heskett wrote:
>> Ahh, thank you very much.  But I have 7.0, supposedly fixed,
>> sigh...  That did fix it, the dvd is burning as I type, again thanks.
>>
>> ???? Can I put this into rc.local so its global?  I guess I will
>> just for effects.  Or is there an option in a make xconfig to reset
>> this to a usable sized limit?, because I can see cups also having
>> problems since I have its render cache set for 127 megs, which
>> should also trigger this.
>
>Well, that's not a limit on how much memory you can map, it's a limit
>on how many pages you can lock into memory (as in, cannot be swapped
>out or written back to disk and reused).  For low-latency
>applications (IE: cd burning) you need to have all memory mlocked so
>that you don't get a low-latency wakup and then promptly lose all
>latency guarantees by swapping madly, but something like CUPS doesn't
>have a problem because it doesn't use mlock() or mlockall().
>
Ah, that clarifies that then, thanks Kyle.

>Cheers,
>Kyle Moffett



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The perversity of nature is nowhere better demonstrated by the fact that, 
when
exposed to the same atmosphere, bread becomes hard while crackers become 
soft.
