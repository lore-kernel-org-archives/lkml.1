Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZHFIHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZHFIHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZHFIHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:07:43 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:62894 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZHFIHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MLTXiLQ2k7wk0+aDanqdkXicLanb/46j/RLirNx6lf6OssQbWVp8qZjUd6GPb2PBwt
         +JcQlAfjNoFgHni/yjyZdeFihumwU5CakC/f1ZRWdhh5jwVnApILIjHdv1RuNxHjf/DD
         XXd5qB8WDCSa8Wddh58QhKzF5Y92Ywo1MPjvM=
MIME-Version: 1.0
In-Reply-To: <2f11576a0908052213m3fba4154ifb73ab1ae2ea74d6@mail.gmail.com>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
	 <20090805163945.056c463c.akpm@linux-foundation.org>
	 <2f11576a0908052213m3fba4154ifb73ab1ae2ea74d6@mail.gmail.com>
Date: Thu, 6 Aug 2009 17:07:41 +0900
Message-ID: <28c262360908060107i4d1d23f3h47c112b48f1d8e48@mail.gmail.com>
Subject: Re: [PATCH for 2.6.31 0/4] fix oom_adj regression v2
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki.

On Thu, Aug 6, 2009 at 2:13 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>> So I merged these but I have a feeling that this isn't the last I'll be
>> hearing on the topic ;)
>>
>> Given the amount of churn, the amount of discussion and the size of the
>> patches, this doesn't look like something we should push into 2.6.31.
>>
>> If we think that the 2ff05b2b regression is sufficiently serious to be
>> a must-fix for 2.6.31 then can we please find something safer and
>> smaller?  Like reverting 2ff05b2b?
>
> I don't think the serious problem is only  this issue, I oppose to
> ignore regression
> bug report ;-)
>
> Yes, your point makes sense. then, I'll make two patch series.
> 1. reverting 2ff05b2b for 2.6.31
> 2. retry fix oom livelock for -mm
>
> I expect I can do that next sunday.
>
>
>> These patches clash with the controversial
>> mm-introduce-proc-pid-oom_adj_child.patch, so I've disabled that patch
>> now.
>
> I think we can drop this because workaround patch is only needed until
> the issue not fixed.


I looked over your this patches.
I can't find out merge point our both idea.

I think it would be better than mine.

As kame pointed out, you patch can solve long stall time of do_each_thread
as well as livelock.

So I will wait for you to finish this work and review then.
I ask you add me in CC, then. :)

Thanks.

>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a hrefmailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
