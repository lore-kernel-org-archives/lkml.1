Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYC1Nip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYC1Nip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYC1NiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:38:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbYC1NiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:38:22 -0400
Message-ID: <47ECF3F9.4040906@redhat.com>
Date: Fri, 28 Mar 2008 09:34:49 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: [OT] Re: [patch for 2.6.26 0/7] Architecture Independent Markers
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <2f11576a0803271008t7574ead1s9ea285d8df57ef1@mail.gmail.com> <20080328101500.GF30863@elte.hu>
In-Reply-To: <20080328101500.GF30863@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> furthermore, and because it's Friday again, let me remind folks that 
> SystemTap has an even more significant bloat problem: the fact that it 
> needs a huge download:

Ingo, that seems very off-topic...

>  Installing:
>    kernel-debuginfo         x86_64     2.6.25-0.163.rc7.git1.fc9  
>    development-debuginfo  198 M
>  Installing for dependencies:
>    kernel-debuginfo-common  x86_64     2.6.25-0.163.rc7.git1.fc9  
>    development-debuginfo   30 M
> 
>  Total download size: 229 M
> 
> for _every_ updated kernel. That 229 MB size reduces the user base of 
> SystemTap (which is otherwise a totally brilliant and cool tool) to 1% 
> of its potential userbase, to those truly desperate persons who really 
> _need_ to get their problem debugged somehow. But it's nowhere near 
> usable as an easy, ad-hoc kernel instrumentation tool, just due to the 
> sheer size it brings.

Sure, it is a thorny issue especially for users of daily-kernel-updating
distribution.

However, when updating kernel from tarball, We can get full set of debuginfo
just by building kernel with CONFIG_DEBUG_INFO. I think it is enough
usable for kernel developers.

BTW, we already started working on the symbol-table based probing.
http://sources.redhat.com/bugzilla/show_bug.cgi?id=4311

> for heaven's sake, we can have 3 years of _full Linux kernel history_, 
> with all 87875 commits, with full changelog and dependencies and full 
> source code included, packed into a rather tight, 180 MB git repository 
> ...
> 
> [ and then i havent even begun about the on-disk footprint of this 
>   monstrum, after the packages have been installed: an additional 850 MB.
>   Puh-lease ... ]

Thank for Moore's law and all storage engineers, nowadays we can buy
an 1TB(=1000GB!) HDD with less than $300!(I also surprised...)
And many other compressed filesystem can be used for saving disk space.

Best regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

