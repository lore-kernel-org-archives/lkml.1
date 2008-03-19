Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYCTAF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYCTAF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965801AbYCSXEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:04:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19573 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965796AbYCSXEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:04:22 -0400
Message-ID: <47E19BC2.2030100@oracle.com>
Date: Wed, 19 Mar 2008 16:03:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Laurent Vivier <Laurent.Vivier@bull.net>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v4]  Modify loop device to be able to manage partitions
 of the disk image
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>	<12059301672966-git-send-email-Laurent.Vivier@bull.net>	<20080319131106.61d7fa0c.randy.dunlap@oracle.com>	<1205958281.4758.7.camel@frecb07144> <20080319142821.73d280f3.akpm@linux-foundation.org>
In-Reply-To: <20080319142821.73d280f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 19 Mar 2008 21:24:41 +0100
> Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> 
>> Le mercredi 19 mars 2008 __ 13:11 -0700, Randy Dunlap a __crit :
>>> On Wed, 19 Mar 2008 13:36:07 +0100 Laurent Vivier wrote:
>>>
>>>> This patch allows to use loop device with partitionned disk image.
>>>>
>>>> Original behavior of loop is not modified.
>>>>
>>>> A new parameter is introduced to define how many partition we want to be
>>>> able to manage per loop device. This parameter is "max_part".
>>> What happened to the update to Documentation/kernel-parameters.txt
>>> that was in v3?
>> Well, perhaps I didn't understand the comment of Andrew:
>>
>> "This shouldn't be needed."
>>
>> I though it means I should remove it. So, Andrew ???

First of all, I didn't see Andrew's message until awhile after yours,
due to some kind of email problems...

> No, given that all module_param() options are available via the boot
> command line when the module is linked into vmlinux, we don't document them
> separately.

Thanks.  That's news to me.  Not that I mind the news.

> There should be a way of auto-generating all the documentation for all the
> module parameters from their MODULE_PARM_DESC's.  And there probably is,
> but I'm not sure how this is done (?)

No, nothing in tree like that.

Would such an auto-generator use source files or compiled modules?
Using the latter means that (a) something like allmodconfig must be done
and (b) it only works for the compiled $ARCH(es), whereas using source code
has neither of those "problems."

I can work on updating
http://www.xenotime.net/linux/scripts/module-params (from Oct-2006).
Comments welcome.


> (does `make help', fails to spot it).
> 
> You can do `modinfo loop' but that probably doesn't work if
> CONFIG_BLK_DEV_LOOP=y?


-- 
~Randy
