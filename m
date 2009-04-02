Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbZDBLyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbZDBLyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZDBLxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:53:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:47612 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZDBLxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JWIMF18xJtLrhSkGDyrxvG3Cg4Z4JGseENALBhE5ehd0PGRynOPO8wmVviEEhEIVay
         DzEFPjy8kmqeSB5D7tnV2K8jlXATENYKQu7zrzVOwj4ePqn92+Vs/msaxlYJZzB/I6XX
         cIRlMaMzh8yKoekV0xyiYcDIxIgqKyhTKIAhA=
MIME-Version: 1.0
In-Reply-To: <1238670826.8530.5837.camel@twins>
References: <a6b9f31a0904010758r23767adco16ea4ee45d7e158e@mail.gmail.com>
	 <1238670826.8530.5837.camel@twins>
Date: Thu, 2 Apr 2009 20:53:49 +0900
Message-ID: <a6b9f31a0904020453o2b3177b7p99bcf332131e2f5b@mail.gmail.com>
Subject: Re: [RFC] Improving scheduler for asymmetric multi-core processor in 
	Google's summer of code
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Amithash Prasad <amithash@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 20:13, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-04-01 at 23:58 +0900, Hitoshi Mitake wrote:
>> Hi,
>>
>> I found an interesting problem, scheduling on Asymmetric multi-core processor.
>>
>> According to this paper,
>>
>> http://portal.acm.org/citation.cfm?id=1362694&dl=GUIDE&coll=GUIDE&CFID=28487975&CFTOKEN=68150071
>>
>> taking performance asymmetry into consideration on multi-core CPUs can
>> improve scheduler performance.
>> (And I think discarding this could have bad consequences.)
>>
>> So I have a question:
>> Is the current scheduler of Linux aware of possible performance
>> asymmetry of the cores?
>
> It does not.
>
>> By performance asymmetry I mean a case where different cores run on
>> different frequencies.
>>
>> If something tackling this issue is not implemented yet,
>> I would like to work on that as a project of Google's summer of code.
>
> Have at it.
>
> Its a rather delicate business though and should also include scaling
> balancing decisions based on time taken by IRQs and RT tasks as well as
> incorporate feedback from the cpu. The latter includes things like
> cpufreq, but also effective work done by threads on a core.
>
> Its been on my todo list for quite a while, but haven't managed to get
> something robust together.
>

Amithash and Peter,

I evaluated the performance of Linux on ASMP.
I made web page to describe this:
http://www.dcl.info.waseda.ac.jp/~mitake/asmp/
because I want to use some pictures for easy to read.
(Sorry for my broken English! I'm Japanese and not good at English.)

And it seems that there's no problem at least on my evaluation.
So I can't define problem clearly now. I pass this year's
GSoC.(Deadline is coming soon.)

But I'll continue to research ASMP as a private project.
As Peter told, this is delicate business.
For example, this may be more difficult problem when realtime task exists.
(Setting frequency low may be fatal for deadline of RT tasks.)

Thanks a lot!

Hitoshi
