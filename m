Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbYG1SMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbYG1SMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYG1SMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:12:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37371 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752296AbYG1SMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:12:16 -0400
Message-ID: <488E0BFF.7080607@sgi.com>
Date: Mon, 28 Jul 2008 11:12:15 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] cpus4096 fixes
References: <20080727190601.GA764@elte.hu> <200807281042.12860.rusty@rustcorp.com.au> <20080727200636.96da12d0.akpm@linux-foundation.org> <200807281634.43036.rusty@rustcorp.com.au>
In-Reply-To: <200807281634.43036.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 28 July 2008 13:06:36 Andrew Morton wrote:
>> On Mon, 28 Jul 2008 10:42:12 +1000 Rusty Russell <rusty@rustcorp.com.au> 
> wrote:
>>> The 4k CPU patches have been sliding in without review up until now.
>> wot?
> 
> This surprises you?  I stumbled across the cpumask_of_cpu() bug because I 
> happened to want it for stop_machine and read the damned code.  But it lead 
> me to the surrounding code, which is pretty questionable.  An arch-specific 
> map, rather than depending on NR_CPUS?  Adding set_cpus_allowed_ptr() instead 
> of changing set_cpus_allowed()?  Macros which declare things and may or may 
> not do an allocation/free?  Finally a patch so horrifically ugly that it 
> can't be ignored any more gets all the way to Linus.
> 
> Overall, it seems like an attempt to sneak in gradual workarounds for cpumasks 
> on the stack, rather than a coherent plan.  I understand the temptation to 
> avoid an "are we prepared to pay this price for large NR_CPUS?" discussion, 
> but we need it anyway.
> 
> And that's what I call "review".
> Rusty.


I'm not sure I can respond to all, but some of this was brought up in discussions
previously, and I always took the advice and objections that came up.  I don't
think anything went in that wasn't (at least in general) agreed upon by those that
reviewed any of my changes.  If I did some things wrong, I apologize and I'll take
full blame ("rookie mistakes?" ;-).

Thanks,
Mike
