Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYJAHxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYJAHxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYJAHxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:53:10 -0400
Received: from www.tglx.de ([62.245.132.106]:41902 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbYJAHxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:53:09 -0400
Date: Wed, 1 Oct 2008 09:51:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall
In-Reply-To: <20081001063945.0B44D154215@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0810010950320.5549@apollo.tec.linutronix.de>
References: <20080930194445.978351700@linutronix.de> <20081001063945.0B44D154215@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Roland McGrath wrote:

> The core of this looks fine to me.  Presumably this would be expressed in
> userland as pthread_sigqueue.

Yes, that would match the pthread_kill then.

> You are missing compat_sys_rt_tgsigqueueinfo for e.g. the
> arch/x86/ia32/ia32entry.S table.

Duh, did not think about that.
 
> The clean way to do that would be a do_rt_tgsigqueueinfo taking
> the siginfo_t * (not __user).  That is, just split out the copy_from_user,
> so compat_sys_rt_tgsigqueueinfo does copy_siginfo_from_user32 instead.

Will do.

Thanks,

	tglx
