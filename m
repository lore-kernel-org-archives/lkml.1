Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbYJBI63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbYJBI63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYJBI6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:58:20 -0400
Received: from www.tglx.de ([62.245.132.106]:52479 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYJBI6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:58:19 -0400
Date: Thu, 2 Oct 2008 10:57:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-api@vger.kernel.org
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall V2
In-Reply-To: <cfd18e0f0810010757j7a9f6deaj47a06f30e371af1e@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0810021055400.5549@apollo.tec.linutronix.de>
References: <20081001095204.343984413@linutronix.de> <cfd18e0f0810010757j7a9f6deaj47a06f30e371af1e@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008, Michael Kerrisk wrote:
> [CC+=linux-api@vger.kernel.org]
> 
> On Wed, Oct 1, 2008 at 12:01 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Changes vs. V1: compat_sys_rt_sigqueueinfo implemented. Thanks Roland !
> >
> > sys_kill has a counterpart sys_tgkill which allows to send signals to
> > a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
> >
> > Aside of the asymetry it is a show stopper for migrating applications
> > from other unix-alike RTOSes.
> >
> > The following patch series implements rt_tgsigqueueinfo and hooks it
> > up for x86.
> 
> This is an excellent candidate for CCing to the new linux-api@vger
> (http://thread.gmane.org/gmane.linux.ltp/5658/), since it is an API
> change.

Oops, yes forgot about that.
 
> > Find below the raw documentation.
> 
> Thanks -- I'll work that up into a man page when this gets closer to release.

I'll send out test code later this week - once I get a breather from
bugs and regressions again.

Thanks,

	tglx

