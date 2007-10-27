Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbXJ0HvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbXJ0HvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 03:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXJ0Hux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 03:50:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38076 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbXJ0Huw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 03:50:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, kir@swsoft.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       kir@openvz.org, Cedric Le Goater <clg@fr.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>
	<m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>
	<20071027002448.GH30533@stusta.de>
	<m18x5puyw7.fsf@ebiederm.dsl.xmission.com>
	<20071027020408.GO30533@stusta.de>
	<20071026191845.fd0f75c8.akpm@linux-foundation.org>
	<m18x5pte18.fsf@ebiederm.dsl.xmission.com>
	<20071026214046.c61e248d.akpm@linux-foundation.org>
Date: Sat, 27 Oct 2007 01:41:43 -0600
In-Reply-To: <20071026214046.c61e248d.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 26 Oct 2007 21:40:46 -0700")
Message-ID: <m1prz1rolk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> Given that a lot of this development will hopefully happen over the next
> two months, ...

A lot.  Various pieces are a major effort in their own right.
Improving the kthread API so it can be used universally and
allow removal all of the kernel_thread users.
Reducing to an absolute minimum usage of pid_t.

I know several of the things with signal handling had Oleg
scratching his head.

There is enough development there I question if the code will even be
canidates for merging into 2.6.24.

I can imagine an -mm tree that has everything ready to go in
the next two months.

>> It hurts me to even ponder what thinking makes it that 
>> CONFIG_EXPERIMENTAL isn't enough to keep a stable distro
>> from shipping the code in their stable kernel, and locking us into
>> trouble.
>> 
>> With that said.  I think I should just respin the patchset now and add
>> the "depends on BROKEN".  
>
> it doesn't make sense to make it all dependent upon BROKEN now.  Better
> would be to make it dependant upon CONFIG_SOMETHING_ELSE now, which depends
> upon EXPERIMENTAL and which will, around -rc6, be changed to depend upon
> BROKEN.

So we now have my patch which makes it depend on CONFIG_PID_NS.  
Which is what started this thread. 

> If that makes sense.

Yes.

> It's all a bit unusual and complex, but this is an exceptional set of
> features - let's hang in there.

Sure.  One small step at a time.

- Step One add a config option.

Eric

