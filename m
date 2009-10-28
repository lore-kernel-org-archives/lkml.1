Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZJ1U6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZJ1U6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZJ1U6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:58:43 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:58343 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbZJ1U6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:58:41 -0400
Date: Wed, 28 Oct 2009 21:58:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
       mcree@orcon.net.nz, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools, Alpha: Add Alpha support to perf.h
Message-ID: <20091028205844.GC20363@merkur.ravnborg.org>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz> <tip-fcd14b3203b538dca04a2b065c774c0b57863eec@git.kernel.org> <84144f020910260508n47ef067ci4adfd02cd3f87edd@mail.gmail.com> <20091026122247.GA31982@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026122247.GA31982@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > OK, I'll bite. We tell userspace developers not to include kernel 
> > headers. Why is it okay for perf to do it (especially for something 
> > that's in asm)?
> 
> The main counter-argument against inclusion was always "what if we break 
> them accidentally". I.e. it can become a semi-ABI - stuff we cannot 
> change because we cannot change the outside projects. With perf this 
> cannot occur - it's all in one Git tree and can always be fixed/changed.
> 
> Note that we reuse a couple of other facilities in tools/perf as well - 
> linux/list.h, rbtree.c, etc. - and this is good - you can code perf as 
> if you were hacking on the kernel! ;-)

I see no reasons why perf should not use the exported headers
in the default case. unistd.h from alpha is indeed exported.

If perf then on top of that uses some kernel internal
stuff - then pick it up there.
But having perf in the kernel is not an excuse for avoinding
the exported headers.

	Sam
