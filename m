Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbYDVThx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbYDVThx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYDVThp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:37:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:62902 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYDVTho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=E9Tu33tff0xV7EnjHqaKO+IXGkirBf0MCGrl7hUtTMfmD4YOhrtqI/1GW/uvBQ0xj2iltagTaRu3dbh35P/LUDGYEvy+TmCZkV+P8vpafbWiS1+JaukLh4WTuOZ/VlseIOj1ILHr9Qq2dFDo0uQ9b5ryu/SxSXGPuFM0ak1tWEQ=
Message-ID: <480E3E83.3050007@gmail.com>
Date: Tue, 22 Apr 2008 23:37:39 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: random clean-ups
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com> <20080421122504.GF6788@elte.hu> <90edad820804210541h26c8e66dh70895f32e4b4038d@mail.gmail.com> <20080422140203.GB24966@elte.hu> <480E3A00.7060401@gmail.com> <20080422192215.GA11665@elte.hu>
In-Reply-To: <20080422192215.GA11665@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar пишет:
> * Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> 
>>>> This should be #1, #3 and #4. The NexGen patch, which was #2 in the 
>>>> original series, have been replaced by a bigger patch that kills 
>>>> NexGen altogether. Plese check, if you have time for that.
>>> yeah, i did the right thing and described the wrong selection :) You 
>>> can check the end result via:
>>>
>>>   http://people.redhat.com/mingo/x86.git/README
>> ... which indicates that #4 is still not there, which is a pity, since 
>> the #4 patch gave me a more-than-negligible binary shrinkage for the 
>> case CONFIG_SYSFS=n :)
> 
> oh, yes, i forgot - that collided with some changes to that file - 
> percpu changes and 4Kcpu support. I think we should delay #4 to a bit 
> later, when the other changes have gone in - or you could try to send a 
> patch against sched-devel.git/latest which should show the merged up 
> status of that code:
> 
>   http://people.redhat.com/mingo/sched-devel.git/README
> 
> sched-devel/latest has all of the x86 tree 'embedded' in it - plus the 
> 4Kcpu changes as well.

OK, let's wait till the things calm down a bit. The "sysfs disabled" case
should be rare enough to not be in a big rush here.

I'll resubmit this after the merge window has closed.

Thanks,
Dmitri

> 
> 	Ingo
> 

