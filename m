Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085Ab0AWFXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0AWFXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 00:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119Ab0AWFXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 00:23:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab0AWFXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 00:23:51 -0500
Date: Sat, 23 Jan 2010 06:22:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ozan ??a??layan <ozan@pardus.org.tr>, Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, stable@kernel.org,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: deprecate CONFIG_X86_CPU_DEBUG and schedule it for rapid
 removal
Message-ID: <20100123052257.GA19399@elte.hu>
References: <4B4E1633.8010700@pardus.org.tr>
 <201001162312.34189.rjw@sisk.pl>
 <4B52D6E2.8000904@pardus.org.tr>
 <201001171444.14551.rjw@sisk.pl>
 <4B53B8DD.9000809@zytor.com>
 <20100122165356.55cf88aa.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1001221755320.13231@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001221755320.13231@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 22 Jan 2010, Andrew Morton wrote:
> > 
> > We know that enabling this feature will cause some machines to hang,
> > and that this problem has existed for six months.
> > 
> > Would it not be better to fix that problem (perhaps just with the
> > revert) so that 2.6.33, 2.6.32.x and earlier can be fixed?  Then we can
> > nuke the feature in 2.6.34.
> 
> Another way of looking at is "we know it's been broken for six months, and 
> clearly nobody really ever enabled it in any distro, and even getting a bug 
> report on it took forever. So why keep it around at all"?
> 
> So I'd personally rather just remove it outright than deprecate it or even 
> try to fix it. Since clearly absolutely nobody depends on it.
> 
> The usual reason for deprecating a feature is to give people time to move 
> away from it, but since clearly nobody uses it...

Excellent - that makes it all even simpler to handle.

	Ingo
