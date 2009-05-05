Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbZEELnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbZEELnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZEELnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:43:10 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:45620 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbZEELnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:43:09 -0400
Message-ID: <4A00264C.3020004@msgid.tls.msk.ru>
Date: Tue, 05 May 2009 15:43:08 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
References: <49FEB572.4010909@msgid.tls.msk.ru> <20090504111243.GH23223@one.firstfloor.org> <200905042355.47109.rjw@sisk.pl> <200905051338.46436.arnd@arndb.de>
In-Reply-To: <200905051338.46436.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 04 May 2009, Rafael J. Wysocki wrote:
>> In fact I don't think the 32-bit user space will work with 64-bit kernels as is
>> in this particular case, because of the different pointer size.
>>
>> Having a quick look at the code (I don't remember the details right now)
>> I think most probably it could be modified to handle this case too, but I'm not
>> really sure.
> 
> I don't see anything in the snapshot code that passes pointers to the
> kernel, so why should the pointer size matter?

It's the userspace part (uswsusp).  In particular it parses swap
on-disk data structures.

But in any case, without compat_ioctl32 in kernel userspace part
can not be fixed.

/mjt
