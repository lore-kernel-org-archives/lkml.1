Return-Path: <linux-kernel-owner+w=401wt.eu-S1764468AbZAONKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764468AbZAONKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbZAONKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:10:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:50525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854AbZAONKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:10:10 -0500
Message-ID: <496F3577.4020303@kernel.org>
Date: Thu, 15 Jan 2009 22:09:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu>
In-Reply-To: <20090115122222.GI22850@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 13:09:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> And this happens to be the third time I wrote the above addresses in 
>> this thread.  :-)
> 
> You know the drill: you have to explicitly ask for stuff to be pulled :-)

Heh... Jeff usually just regenerates patches from the git tree or just
takes the mails, so not too familiar with pull requests.  :-)

> ( Otherwise if i just pull it and you rebased it or were unhappy about it 
>   in some fashion we all add stress that could have been avoided. )
> 
> So i've picked up these commits from you:
> 
>  d060676: x86_64: misc clean up after the percpu update
>  6d459d9: x86_64: convert pda ops to wrappers around x86 percpu accessors
>  d7051ef: x86_64: make pda a percpu variable
>  4fe7fdf: x86_64: merge 64 and 32 SMP percpu handling
>  44f5fbd: x86_64: fold pda into percpu area on SMP
>  cc1d354: x86_64: use static _cpu_pda array
>  c701268: x86_64: load pointer to pda into %gs while brining up a CPU
>  7e36da9: x86_64: make percpu symbols zerobased on SMP
>  3fc860d: x86_32: make vmlinux_32.lds.S use PERCPU() macro
>  bc497c7: x86_64: Cleanup early setup_percpu references
>  769d780: x86: make early_per_cpu() a lvalue and use it
>  66cbc8e: x86_64: fix pda_to_op()
> 
> into tip/x86/percpu.
> 
> I did the following small reorganizations:
> 
>  - i rebased them on top of tip/cpus4096, tip/x86/cleanups and 
>    tip/x86/urgent - that is a stable base.
> 
>  - i resolved the conflicts that arose due to recent cpumask and upstream 
>    changes.
> 
>  - i standardized the commit logs to the usual x86 style and added 
>    Original-From: Mike Travis tags to those patches that were derived from 
>    Mike's patches.
> 
> If they pass testing they'll be stable commits from that point on, and you 
> can base your git trees on that topic branch.
> 
> Could you please have a look at the end result? Here are the Git 
> coordinates for it:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/percpu

Yeap, looks fine to me.

> If we are happy with it then these commits can be stable commits from now 
> on, and you can base your future changes on this Git tree, and i can pull 
> updates from you without having to rebase them.
> 
> Does that workflow sound OK to you?

Yes, perfectly okay.

Thanks.  :-)

-- 
tejun
