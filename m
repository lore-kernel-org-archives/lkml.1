Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbXIDIYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbXIDIYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXIDIYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:24:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:52496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751680AbXIDIYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:24:32 -0400
Cc: corbet@lwn.net, jengelh@computergmbh.de, hch@lst.de, stable@kernel.org,
       drepper@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rdunlap@xenotime.net,
       davidel@xmailserver.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 04 Sep 2007 10:24:31 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <20070904011800.762523a4.akpm@linux-foundation.org>
Message-ID: <20070904082431.56690@gmx.net>
MIME-Version: 1.0
References: <20070825064114.107820@gmx.net>
	<Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
	<46DD116C.4040301@gmx.net> <20070904011800.762523a4.akpm@linux-foundation.org>
Subject: Re: [PATCH] Revised timerfd() interface
To: Andrew Morton <akpm@linux-foundation.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19uKjdKaiZuel6cz+mxeGlg0VbSNsDCuCY91ywPZC
 vyNB6f+j1z3lwPUE+XMDvfJ85LjXBlvRretw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: Xnq2LmxDTlI8SM76DGlr7chOU2poZVn4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> > Neither of the proposed APIs (either my multiplexed version of 
> > timerfd()
> > or Jon's/my idea of using three system calls (like POSIX timers), or
> > the notion of timerfd() integrated with POSIX timers) is more
> > complicated than the existing POSIX timers API.
> > 
> > The ABI change doesn't really matter, since timerfd() was broken in
> > 2.6.22 anyway.
> > 
> > Both previous APIs provided the features I have described provide:
> > 
> > * the ability to fetch the old timer value when applying
> >   a new setting
> > 
> > * the ability to non-destructively fetch the amount of time remaining
> >   on a timer.
> > 
> > This is clearly useful for timers -- but you have not explained why
> > you think this is not necessary for timerfd timers.
> 
> <wakes up>
> 
> I'd have thought that the existing stuff would be near-useless without 
> the capabilities which you describe?

Not useless, but certainly less functional than it can/should be
(and with not too much effort on the kernel implementation side).

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

