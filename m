Return-Path: <linux-kernel-owner+w=401wt.eu-S1422850AbXCOGaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850AbXCOGaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422841AbXCOGaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:30:35 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:42762 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422813AbXCOGae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:30:34 -0400
Date: Thu, 15 Mar 2007 02:30:33 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
In-reply-to: <45F8CF68.8060400@madrabbit.org>
To: linux-kernel@vger.kernel.org
Cc: Ray Lee <ray@madrabbit.org>
Message-id: <200703150230.33141.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703130428.11014.gene.heskett@gmail.com>
 <200703142312.48852.gene.heskett@gmail.com> <45F8CF68.8060400@madrabbit.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007, Ray Lee wrote:
>Gene Heskett wrote:
>> Here is an example
>> [root@coyote data]# dd if=00010.coyote._lib.1 bs=32k count=1
>> AMANDA: FILE 20070314104344 coyote /lib  lev 1 comp .gz program
>> /bin/tar To restore, position tape at start of file and run:
>>  dd if=<tape> bs=32k skip=1 |  /bin/gzip -dc |  /bin/tar -f - ...
>>
>> And the elipsis is an error if not removed.  Then one is supposed to
>> be able to redirect tars output with the usual >/tmp/test/ syntax
>>
>> So:
>> [root@coyote data]# dd if=00010.coyote._lib.1 bs=32k
>> skip=1 |  /bin/gzip -dc |  /bin/tar -f - >/tmp/test/
>> -bash: /tmp/test/: Is a directory
>>
>> which is the return from any variation in how the redirect is done.
>>
>> So what is it that am I doing wrong in the above command line?, so I
>> can add it to my helper scripts to be published eventually on
>> zmanda.org.
>
>One of us is confused, and it may very well be me, but...
>
>the /bin/tar -f - >/tmp/test/ looks to me like it should fail exactly as
>bash says it does. the output redirect (>) will only write out to a
>file, not a directory. (So, /tmp/file should work, /tmp/file/ won't.)
>
>Are you trying to redirect where the files get restored? That should be
>done with a cd before doing the uncompress.
>
>Or am I misunderstanding what you're telling me?
>
>Ray

No, apparently its me that's been running with a fubar'd understanding.
I was certain that tar (or bash) should have been able to put the 
recovered files IN the directory /tmp/test but that turns out to need 
more options after the '-f -' section of that sample line I posted.

Thanks.  A bunch..

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Mal: "You are very much lacking in imagination."

Zoe: "I imagine that's so, sir."
				--Episode #8, "Out of Gas"
