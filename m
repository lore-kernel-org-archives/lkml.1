Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbXDKMYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbXDKMYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 08:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXDKMYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 08:24:07 -0400
Received: from ozlabs.org ([203.10.76.45]:58738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbXDKMYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 08:24:04 -0400
Subject: Re: [PATCH, take5] FUTEX : new PRIVATE futexes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070411111913.6115dac8.dada1@cosmosbay.com>
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
	 <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	 <20070405194942.1414c030.dada1@cosmosbay.com>
	 <20070407104339.6674336b.dada1@cosmosbay.com>
	 <20070411111913.6115dac8.dada1@cosmosbay.com>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 22:23:38 +1000
Message-Id: <1176294219.14322.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 11:19 +0200, Eric Dumazet wrote:
> Hi Andrew
> 
> Update on this take5 :
> 
> - Rebased on linux-2.6.21-rc6-mm1 + get_futex_key() must check proper alignement for 64bit futexes
> - compile test on x86_64 (one minor typo)

> - Added Rusty in CC since he may have to change drivers/lguest/io.c
> again, since get_futex_key() have yet another parameter (fshared). (I
> couldnt find this file in 2.6.21-rc6-mm1 tree)

That's fine.  I just use the futex key lookup code to get a unique key
for shared memory between lguests (this is how lg.ko decides if they can
send DMA & interrupts to each other).

Looks like Andrew has already patched the lguest callers (I resubmitted
the moved lguest code just today).

Thanks!
Rusty.
PS.  As original futex author, I could have been cc'd on these patches
anyway.  But since the futex code has become unforgivably ugly (but, oh
so fast for pthreads), it's probably better not to see them 8)


