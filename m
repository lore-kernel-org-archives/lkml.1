Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYCTVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYCTVhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYCTVh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:37:27 -0400
Received: from mail.tmr.com ([64.65.253.246]:44547 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315AbYCTVh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:37:27 -0400
Message-ID: <47E2D8D2.9090407@tmr.com>
Date: Thu, 20 Mar 2008 17:36:18 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Laurent Vivier <Laurent.Vivier@bull.net>, randy.dunlap@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v4]  Modify loop device to be able to manage partitions
   of the disk image
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>	<12059301672966-git-send-email-Laurent.Vivier@bull.net>	<20080319131106.61d7fa0c.randy.dunlap@oracle.com>	<1205958281.4758.7.camel@frecb07144> <20080319142821.73d280f3.akpm@linux-foundation.org>
In-Reply-To: <20080319142821.73d280f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
> 
> No, given that all module_param() options are available via the boot
> command line when the module is linked into vmlinux, we don't document them
> separately.
> 
I totally don't understand this comment, where is the file with the list 
of canonical module parameters now? I must have missed the discussion of 
why it is changed. And what has the boot command line or linking modules 
to do with the documentation file?

> There should be a way of auto-generating all the documentation for all the
> module parameters from their MODULE_PARM_DESC's.  And there probably is,
> but I'm not sure how this is done (?)
> 
> (does `make help', fails to spot it).


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
