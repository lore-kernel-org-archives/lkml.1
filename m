Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbYETLw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbYETLw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbYETLwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:52:16 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58496
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762407AbYETLwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:52:14 -0400
Message-ID: <4832BB6A.8010809@qumranet.com>
Date: Tue, 20 May 2008 14:52:10 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <87k5hpgqwa.fsf@basil.nowhere.org> <4832B74F.5040402@qumranet.com> <4832BABA.9040809@firstfloor.org>
In-Reply-To: <4832BABA.9040809@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Makes sense.  I'll send out v3.
>>
>> Is there a similar range on i386?
>>     
>
> Don't think so. Address space is too precious here.
>
> What you could probably do is to unmap one fixed page in some range
> that is always split to 4K pages anyways and use that. Perhaps somewhere
> in the 640k-1MB range. But if you're unlucky this might require a
> variable, not a constant.
>   

I guess a fixmap would work for this.  But then the offsets added to 
that page would need to be limited to 4K.

-- 
error compiling committee.c: too many arguments to function

