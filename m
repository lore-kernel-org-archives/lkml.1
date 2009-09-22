Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbZIVRSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbZIVRSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZIVRSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:18:36 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:54610 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbZIVRSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:18:36 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net CDCE233280E
Message-ID: <4AB906EE.5080300@arcor.de>
Date: Tue, 22 Sep 2009 20:18:38 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
CC: Brian McGrew <brian@visionpro.com>, linux-kernel@vger.kernel.org
Subject: Re: (un)mount ramfs from C code
References: <C6DE438F.127DA%brian@visionpro.com> <4AB905C6.2040605@arcor.de>
In-Reply-To: <4AB905C6.2040605@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 08:13 PM, Nikos Chantziaras wrote:
> On 09/22/2009 07:04 PM, Brian McGrew wrote:
>> Good morning all!
>>
>> So I'm using a ramfs for temporary files, thank you whoever designed
>> that,
>> it works great!
>>
>> I can mkdir, mount, chmoud, readand write and then umount the thing
>> from the
>> command line just fine.
>>
>> What I need now is some method from within my C/C++ code to determine
>> if the
>> ramfs is mounted, if not, then mount it so I can use it and unmount it
>> when
>> I'm done, without making a system call.
>>
>> Can this be done? Is there any access to mount/unmount from C/C++?
>
> I suppose looking at the source code of the 'mount' utility could prove
> very enlightening. You can find it at:
>
> http://www.kernel.org/pub/linux/utils/util-linux-ng

Also, "man 2 mount" will provide docs about the the mount() function in 
<sys/mount.h>.  If for some reason that man page isn't provided in your 
system, you can find a copy at:

   http://linux.die.net/man/2/mount
