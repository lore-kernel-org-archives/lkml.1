Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYJBMyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYJBMyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 08:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYJBMyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 08:54:16 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43250 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753249AbYJBMyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 08:54:15 -0400
Message-ID: <48E4C488.9020408@sgi.com>
Date: Thu, 02 Oct 2008 05:54:32 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/31] cpumask: Documentation
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <200810010849.46874.rusty@rustcorp.com.au> <20081001091325.GA12503@elte.hu> <200810021036.29054.rusty@rustcorp.com.au>
In-Reply-To: <200810021036.29054.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 01 October 2008 19:13:25 Ingo Molnar wrote:
>> that looks very sane to me.
> 
> Thanks, it's reasonably nice.  The task of hitting all those cpumask_t users 
> is big, and I don't think we can do it in one hit.
> 
>> one small request:
>>> I'll commit these to my quilt series today.
>> IMHO, an infrastructure change of this magnitude should absolutely be
>> done via the Git space. This needs a ton of testing and needs bisection,
>> a real Git track record, etc.
> 
> Not yet.  Committing untested patches into git is the enemy of bisection; if 
> one of my patches breaks an architecture, they lose the ability to bisect 
> until its fixed.  If it's a series of patches, we can go back and fix it.
> 
> Now, once it's been tested a little, it's better for you to git-ize it and 
> I'll send you patches instead.  But I want some more people banging on it, 
> and a run through linux-next first...
> 
> If Mike's happy to work on these as a basis, we should be able to get there 
> soon; the patches are sitting in my tree at http://ozlabs.org/~rusty/kernel/ 
> (see rr-latest symlink).

Absolutely!  I may have my own concerns and preferences but the end goal is
far more important.  I'll take a look at it today.  [My only other pressing
matter is convincing Ingo to accept the SCIR driver (or tell me how I need
to change it so it is acceptable), so my management is happy... ;-)]

> 
> Thanks,
> Rusty.
> PS.  To emphasize, I haven't actually *booted* this kernel.  My test machines 
> are still in transit as I move (and ADSL not connected yet... Grr...)

Since our approaches are not different in concept, I can assure you that it
works... ;-)  And as Ingo and others have noted, the infrastructure is easy
to verify, it's the allocation of the temporary cpumasks that will be more
difficult to test.

Cheers,
Mike

