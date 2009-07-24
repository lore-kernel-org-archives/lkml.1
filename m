Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZGXPn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZGXPn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZGXPn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:43:26 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:55420 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZGXPnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pLUm6/SW1++YvZd/wb1s4ytp2EcgR4nw97VG9+mizt8AcBCN8ktvjSWI2k0AhpmTTM
         c8znJXy0foybkxyz8do2YCe+xdTEsLuX5SyFrmrgkhOJd9785jEb0eSDVWifblJR/zmu
         EmRYM8vq5GQ79Qr4nSDwFqBZmo/j1RCUKMEDU=
MIME-Version: 1.0
In-Reply-To: <1248449070.6987.126.camel@twins>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
	 <1248442415.6987.56.camel@twins>
	 <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
	 <1248443656.6987.61.camel@twins>
	 <454c71700907240704o32dcdeb3v57845eb9472dd04c@mail.gmail.com>
	 <1248446909.6987.110.camel@twins>
	 <454c71700907240807t5b682e7cv52534f41d3be961a@mail.gmail.com>
	 <1248449070.6987.126.camel@twins>
Date: Fri, 24 Jul 2009 23:43:25 +0800
Message-ID: <454c71700907240843v7a1de45eo6551fcda9b876234@mail.gmail.com>
Subject: Re: report a bug about sched_rt
From: sen wang <wangsen.linux@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/24 Peter Zijlstra <peterz@infradead.org>:
> On Fri, 2009-07-24 at 23:07 +0800, sen wang wrote:
>> 2009/7/24 Peter Zijlstra <peterz@infradead.org>:
>> > On Fri, 2009-07-24 at 22:04 +0800, sen wang wrote:
>> >
>> >> just one question:
>> >> if cpu is free and there is running state task, how you do?
>> >> schedule the task up? or schedule idle task up?
>> >
>> > Well, when an RT group is over the bandwidth limit I don't consider them
>> > runnable. Therefore, failing to find any other tasks, we run the idle
>> > task.
>> >
>>
>> you havn't anwser the question: if cpu is free, should we  schedule the
>> running state task or idle task?
>
> It it not runnable because the group is over its limit.
>
>> face the error and fix it! ok?
>
> Please tone down and re-read the explanations I gave.
>
> The throttle is an H-CBS services for RT task groups, meant to provide
> isolation through a fixed resource guarantee.
>
> Any process actually hitting the throttle means a miss configured system
> -- unless its a temporary overload and you're able to deal with those.
>
> The single group case is simply the trivial case thereof.
>
> Your proposed change does not generalize to such a framework, and while
> it might work with the current code, it doesn't serve a use-case
> considered in this architecture and will render the interface
> inconsistent.
>
> Furthermore, future work in this area will not be able to support your
> changed semantics in a sane fashion.
>
> I've yet to see any coherent explanation of your problem, and quite
> frankly I find your attitude offensive.
>
> As you say, Linux is an open-source effort, and you're free to do with
> your copy as you see fit (provided you stick to the rules stipulated by
> the GPLv2). However as co-maintainer of the mainline scheduler I see no
> reason to entertain your change, nor for that matter to continue this
> discussion.
>
>

sorry for my tone, If you feel hurted. I apologize.

But I still hold my viewpoint. I just want the 100-x time should be
used by running  task.
