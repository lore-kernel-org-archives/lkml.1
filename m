Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXIVXVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXIVXVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 19:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbXIVXVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 19:21:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:36573 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXIVXVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 19:21:24 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 22 Sep 2007 16:21:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>, vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       =?X-UNKNOWN?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: RFC: A revised timerfd API
In-Reply-To: <1190496385.4035.124.camel@chaos>
Message-ID: <Pine.LNX.4.64.0709221619430.22085@alien.or.mcafeemobile.com>
References: <46EF7DDA.2070401@gmx.net>  <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com>
  <46F514C9.5010208@gmx.net>  <Pine.LNX.4.64.0709221359190.22085@alien.or.mcafeemobile.com>
 <1190496385.4035.124.camel@chaos>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007, Thomas Gleixner wrote:

> On Sat, 2007-09-22 at 14:07 -0700, Davide Libenzi wrote:
> > On Sat, 22 Sep 2007, Michael Kerrisk wrote:
> > 
> > > So I'm inclined to implement option (b), unless someone has strong
> > > objections.  Davide, could I persuade you to help?
> > 
> > I guess I better do, otherwise you'll continue to stress me ;)
> > 
> > int timerfd_create(int clockid);
> > int timerfd_settime(int ufd, int flags,
> >                     const struct itimerspec *utmr,
> >                     struct itimerspec *otmr);
> > int timerfd_gettime(int ufd, struct itimerspec *otmr);
> > 
> > Patch below. Builds, not tested yet (you need to remove the "broken" 
> > status from CONFIG_TIMERFD in case you want to test - and plug the new 
> > syscall to arch/xxx).
> > May that work for you?
> > Thomas-san, hrtimer_try_to_cancel() does not touch ->expires and I assume
> > it'll never do, granted?
> 
> Davide-san, I have no intention to change that, but remember there is
> this file "Documentation/stable_api_nonsense.txt" :)

Heh, I guess that'll work then ;)



- Davide


