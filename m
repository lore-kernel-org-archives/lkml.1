Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbZLMBsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbZLMBsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934156AbZLMBs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:48:29 -0500
Received: from www.tglx.de ([62.245.132.106]:34360 "HELO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934155AbZLMBs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:48:29 -0500
Date: Sat, 12 Dec 2009 23:31:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <alpine.LFD.2.00.0912121422090.3526@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912122329410.3089@localhost.localdomain>
References: <20091211232805.GA10652@kroah.com> <20091212084611.GA28266@elte.hu> <20091212013927.58d386d1.akpm@linux-foundation.org> <20091212101032.GB25286@elte.hu> <20091212023603.93768833.akpm@linux-foundation.org> <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain> <20091212214235.31429790@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912122244530.3089@localhost.localdomain> <alpine.LFD.2.00.0912121422090.3526@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009, Linus Torvalds wrote:
> On Sat, 12 Dec 2009, Thomas Gleixner wrote:
> > 
> > Just patched the following in and it catched your problem nicely. With
> > your AB/BA fix patch applied everything is fine.
> 
> Actually, the patch I just suggested might be better. Admittedly the 
> CONFIG_PREEMPT case is the more important one (and the one that will catch 
> more cases), but even without preemptyion the might_sleep() in 
> _lock_kernel() (one underscore) would trigger on the case of somebody 
> doing lock_kernel with local interrupts disabled.

Fair enough.

     tglx
