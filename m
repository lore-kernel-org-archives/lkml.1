Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab0BEHcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:32:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606Ab0BEHcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:32:43 -0500
Date: Fri, 5 Feb 2010 08:32:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
Message-ID: <20100205073222.GE9320@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <alpine.DEB.2.00.1002020824001.20769@skynet.skynet.ie>
 <20100202154450.GC27314@elte.hu>
 <21d7e9971002041239i5e842698pd8a775f833fc5d51@mail.gmail.com>
 <20100204204655.GA19050@elte.hu>
 <21d7e9971002041314yf8c55p4a7cb638efa0d24a@mail.gmail.com>
 <21d7e9971002041643i1f6a122fk517abb308606b548@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9971002041643i1f6a122fk517abb308606b548@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@gmail.com> wrote:

> >>
> >> These were random configs - the size doesnt match an allyesconfig, those are
> >> way bigger. My above comment related to the first crash, and to my argument
> >> that all other drivers are fine during bootup - and there's a lot of them.
> >>
> >>> So do you have something you are running after allyesconfig to fix things?
> >>> or have you just got a config that is close enough to allyesconfig.
> >>>
> >>> I'm building kernels with your .config now and boot testing them on the
> >>> full range of hardware I have/
> >>
> >> Thanks. Is there something i can enable to get a better log for you to find
> >> out where (and why) it's hanging? It's still early during bootup so the box
> >> is not particularly debuggable - so i'm not sure i can get a task list dump,
> >> etc., unfortunately.
> >>
> > Do you have NMI watchdog enabled? (does it work that early)
> >
> > a backtrace of where it hangs would be nice,
> >
> > Also a dmesg from booting with drm.debug=15 might help narrow it down
> > also.
> >
> 
> Okay I've booted this on the rv370 + rv380 machines I have, I've no old 
> Athlon's though so I'm trying to get RHTS to give me access to one or two 
> internally,
> 
> Another question, that came to mind, what is there any monitors plugged in? 
> or a KVM or something? if yes can you try without and if no can you try 
> with?
> 
> Also can you add CONFIG_FRAMEBUFFER_CONSOLE as well since I don't think we 
> test often without it.

ok - i'll try your suggestions and send an update - will probably have to 
wait until next week. Feel free to deprioritize the bug until then (i have my 
revert as a short-term band-aid), unless others report similar problems too.

Thanks,

	Ingo
