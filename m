Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbXENVKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbXENVKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXENVK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:10:27 -0400
Received: from gw.goop.org ([64.81.55.164]:51016 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbXENVK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:10:26 -0400
Message-ID: <4648D03F.4090407@goop.org>
Date: Mon, 14 May 2007 14:10:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>	<46489818.4000408@goop.org>	<20070514125946.0f74221c.akpm@linux-foundation.org>	<4648C062.5090704@goop.org>	<20070514133745.5bfc34ac.akpm@linux-foundation.org>	<1179176058.3703.85.camel@mulgrave.il.steeleye.com> <20070514140530.8e0491cf.akpm@linux-foundation.org>
In-Reply-To: <20070514140530.8e0491cf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 14 May 2007 15:54:18 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>
>   
>> On Mon, 2007-05-14 at 13:37 -0700, Andrew Morton wrote:
>>     
>>> On Mon, 14 May 2007 13:02:42 -0700
>>> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>
>>>       
>>>> Andrew Morton wrote:
>>>>         
>>>>> Does "that" have name?  I can find no patch in -mm which appears to have
>>>>> anything to do with SMP consolidation, and this patch applies cleanly to
>>>>> the current -mm lineup.
>>>>>   
>>>>>           
>>>> Sorry, I thought you'd picked this up:
>>>>
>>>>
>>>> Subject: i386: move common parts of smp into their own file
>>>>
>>>> Several parts of kernel/smp.c and smpboot.c are generally useful for
>>>> other subarchitectures and paravirt_ops implementations, so make them
>>>> available for reuse.
>>>>         
>>> Confused.  This patch conflicts a lot with James's one (which I named
>>> voyager-fix-build-broken-by-shift-to-smp_ops.patch).
>>>       
>>> If your "i386: move common parts of smp into their own file" also fixes
>>> Voyager and is preferred then cool, but a) the changelog should tell us
>>> that and b) could James please test it?
>>>       
>> OK, let me try a brief history.  A while ago Eric pointed out that the
>> smp ops patch in -mm would break voyager.  So we worked on (and tested a
>> fix for it).  Part of the fix was the prerequisite patch "i386: move
>> common parts of smp into their own file".  The fix on top of this was
>> called "i386: fix voyager build" which actually fixed the voyager build.
>>
>> I've been nagging Andi for a couple of weeks now to get these two
>> upstream.  Finally he replied that the he wasn't planning on sending the
>> precursor "i386: move common parts of smp into their own file" upstream
>> for 2.6.22.  So I had to do a patch that would fix the voyager build
>> without this ... which is what you have.
>>     
>
> uh, I suspected it was something like that.
>
>   
>> So, you either need the single patch you have, or the other two entitled
>>
>> "i386: move common parts of smp into their own file".
>> "i386: fix voyager build" 
>>     
>
> OK, thanks.  I hereby propose that I send the below
> (voyager-fix-build-broken-by-shift-to-smp_ops.patch) to Linus later today,
> provided it passes local testing.
>
> All those in favour say aye?
>   

OK, but only if you don't want to put "i386: move common parts of smp
into their own file" in front of it, and remove the duplicated code.  I
could send you a third copy if you like.

    J
