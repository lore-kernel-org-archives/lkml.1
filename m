Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbZDLLtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbZDLLtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 07:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbZDLLs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 07:48:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:38174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759549AbZDLLsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 07:48:55 -0400
Subject: Re: [PATCH -tip] x86: apic/x2apic_cluster.c
 x86_cpu_to_logical_apicid should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20090412105132.GA25392@elte.hu>
References: <1239434726.4418.24.camel@localhost.localdomain>
	 <20090412105132.GA25392@elte.hu>
Content-Type: text/plain
Date: Sun, 12 Apr 2009 17:17:38 +0530
Message-Id: <1239536858.2976.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Sun, 2009-04-12 at 12:51 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Impact: reduce kernel size a bit, avoid sparse warning
> > 
> > Fixes sparse warning:
> >   arch/x86/kernel/apic/x2apic_cluster.c:13:1: warning: symbol 'per_cpu__x86_cpu_to_logical_apicid' was not declared. Should it be static?
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Applied, thanks.
> 
> There is a not so small nit:
> 
> > Impact: reduce kernel size a bit, avoid sparse warning
> > 
> > Fixes sparse warning:
> 
> the thing is, we dont 'fix', nor do we 'avoid' Sparse warnings!
> 
> We _read_ them, _understand_ them, and then we act upon them, fixing 
> the problem they expose.
> 
> Or, if there is no problem exposed, we annotate the code to fix the 
> Sparse false positive warning.
> 
> Your changelog does not tell us anything whether you went through 
> that thought process. I had to double-check it and had to create 
> this information from scratch.
> 
> Please take this as a last warning: you send lots of patches that 
> address various things mechanically, often without thinking through 
> the effects. They are expensive to maintain, because they cause 
> churn and because people often have to do more work accepting them 
> than you did creating them!
> 
> You sent a hundred patches in two weeks and they are not applied yet 
> - and this is why: it is expensive to filter through them and if you 
> dont do it we can only do it by simply not taking them all that 
> easily. Taking them simply does not scale.
> 
> And if you write a hundred patches in two weeks you _really_ have to 
> ask yourself whether your quality controls are strong enough before 
> emitting them. There are highly productive members of the Linux 
> community who only send a dozen patches per _year_.
> 

OK, I will be more careful and spend more time on each patch by this way
count will be reduce and quality will also improve.

Please check [git-pull -tip] x86: declaration patches
Sam and Thomas reviewed them and I also fixed the pointed issues.

My problem is I am work-addict I can not sit ideal ;-)

Thanks for your advice,

--
JSR

