Return-Path: <linux-kernel-owner+w=401wt.eu-S1030887AbXDQPt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030887AbXDQPt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030892AbXDQPt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:49:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:43105 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030887AbXDQPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AT5vnGqxgDK/paK5aNiUf/1Nw5Lcdoahsilh1XV1fUsLuo0v82mFAcMZ1HVwa/KG5DJ+lP/G7qKwWS1D2nCh/dWX7vA8I7PObQ4X2KTSnNQJ4x2FvRTeQO6q0iXbWr1mZgNYI0dSeRsCew22PoxXEBOn9iUBQcjtBy/q4Iu2MJQ=
Message-ID: <4624EC51.7080604@googlemail.com>
Date: Tue, 17 Apr 2007 17:48:33 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070207)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
References: <20070416220715.GA4071@elte.hu> <200704170112.35819.caglar@pardus.org.tr> <20070417085936.GB16645@elte.hu> <200704171745.22544.caglar@pardus.org.tr>
In-Reply-To: <200704171745.22544.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> 17 Nis 2007 Sal tarihinde, Ingo Molnar şunları yazmıştı: 
>   
>>> Sorry for delayed response but i just find some free time, do you
>>> still want me to test mainline + "parent-runs first" patch or will i
>>> drop that one and test v2 which can change default behaviour?
>>>       
>> i suspect for now it would be sufficient if you could check the v2
>> patch.
>>
>> if it _works_, please try this:
>>
>>     echo 0 > /proc/sys/kernel/sched_child_runs_first
>>
>> this should break Kaffeine again :)
>>
>> (if it doesnt work then the Kaffeine problem is unrelated to
>> child-runs-first.)
>>     
>
> OK, i tested both plain -rc7 and -rc7 + CFSv2 with while 
> sched_child_runs_first enabled/disabled.
>
> I'm always using same video file and try to reproduce freeze with constantly 
> pressing forward/backward buttons. With CFS 2-3 forward/backward attempt 
> reproduces this behaviour. 
>
> And here are the results.
>
> Mainline still has no issues with both xine-lib/kaffeine and xine-ui 
> (kaffeine-0.8.4, xine-lib-1.1.5 [both xcb enabled], xine-ui-0.99.4). I really 
> try hard to reproduce the freeze, but i can't...
>
> And CFSv2 still fails for both child_runs_first and parent_runs_first cases 
> with same strace output (FUTEX_WAIT).
>   

I have the same problem here ( same packages ).

Even VLC if I go forward/backward and then play again its start to 
ramdom freeze here but only for 1 - 2 seconds maybe.


> If you want me to test something else just ask please :) 
>
> Cheers
>   

