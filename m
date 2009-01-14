Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZANWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZANWek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZANWeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:34:21 -0500
Received: from main.gmane.org ([80.91.229.2]:55410 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbZANWeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:34:19 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: kenneth johansson <ken@kenjo.org>
Subject: Re: 2.6.27.8 scheduler bug - threads not being scheduled for long
 periods
Date: Wed, 14 Jan 2009 22:34:08 +0000 (UTC)
Message-ID: <gklp90$bsi$1@ger.gmane.org>
References: <20090105175641.GA17055@sgi.com> <49625519.4050902@novell.com>
	<20090105185111.GA18084@sgi.com> <49625894.3090706@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 1-1-4-20a.ras.sth.bostream.se
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 13:59:32 -0500, Gregory Haskins wrote:

> Dimitri Sivanich wrote:
>> Hi Greg,
>>
>> On Mon, Jan 05, 2009 at 01:44:41PM -0500, Gregory Haskins wrote:
>>   
>>> Dimitri Sivanich wrote:
>>>     
>>>> I'm wondering if anyone else has run into this problem, and whether
>>>> they've found a resolution for it?
>>>>
>>>>
>>>>   
>>> Hi Dimitri,
>>>   I have observed similar problems on my opensuse 11.0 box (2.6.25
>>> based) when doing kernel builds.  Often times other apps will get
>>> starved (like firefox, etc).  I was talking to peterz about it and he
>>> pointed me at a commit that went into 28-rcx that fixes this (the sha
>>> escapes me at the moment).  I've been meaning to pull the patch into
>>> our 2.6.25 and 2.6.27 trees to verify if it fixes it, but I have
>>> fairly high confidence it will.  Perhaps Peter can point you at the
>>> same patch and you can give it a whirl.  For the time being, can you
>>> see if 28 is fixed?
>>>
>>>
>>>     
>> 2.6.28 appears to be a little bit worse, actually:
>>   
>>   
> Ugg...ok, well thanks for verifying.  I will defer to Peter and Ingo on
> this one.
> 
> Please keep me in the loop on any new findings here, as the problem
> (assuming its the same bug) has been annoying me for months (but
> obviously not enough for me to do something about it ;)
> 
> -Greg

Could this be the same issue as we have in this bug

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/276476

did anyone have a pointer to the patch ??

I'm on .28 and it's much much better but still not 100%.

