Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbYEIARg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbYEIARg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYEIARZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:17:25 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:51358 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYEIARX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:17:23 -0400
Date: Thu, 08 May 2008 20:16:57 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch, -git] drivers/media build fix for modular builds
In-reply-to: <48230C7B.90007@mandriva.org>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Message-id: <200805082016.57622.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20080507134907.4417708b.sfr@canb.auug.org.au>
 <48230C7B.90007@mandriva.org>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2008, Thomas Backlund wrote:
>Stephen Rothwell skrev:
>>
>> Index: linux/drivers/media/Makefile
>> ===================================================================
>> --- linux.orig/drivers/media/Makefile
>> +++ linux/drivers/media/Makefile
>> @@ -2,6 +2,8 @@
>>  # Makefile for the kernel multimedia device drivers.
>>  #
>>
>> +obj-y := common/
>> +
>>  obj-$(CONFIG_VIDEO_MEDIA) += common/
>>
>>  # Since hybrid devices are here, should be compiled if DVB and/or V4L
>
>How about fixing this one already ?
>
Yes please, its biting me too.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
There is more simplicity in the man who eats caviar on impulse than in the
man who eats Grape-Nuts on principle.
		-- G.K. Chesterton
