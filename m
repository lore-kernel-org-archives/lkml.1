Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbXIVNGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbXIVNGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 09:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXIVNGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 09:06:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:48467 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752638AbXIVNF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 09:05:59 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19G4RUjWKhGrZBvuCd6kIoAflNwYkQku1BAShQUAa
	+ZzdHUz+obb1GE
Message-ID: <46F5128A.8050509@gmx.net>
Date: Sat, 22 Sep 2007 15:03:06 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: Thomas Gleixner <tglx@linutronix.de>, davidel@xmailserver.org,
       drepper@redhat.com, geoff@gclare.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@lst.de, corbet@lwn.net,
       rdunlap@xenotime.net, vda.linux@googlemail.com,
       torvalds@linux-foundation.org, lee.schermerhorn@hp.com
Subject: Re: RFC: A revised timerfd API
References: <46EF7DDA.2070401@gmx.net> <46EF7E82.8040503@gmx.net>    <1190106607.2995.97.camel@chaos> <20070918093007.223350@gmx.net>    <1190108542.2995.112.camel@chaos> <20070918110841.235150@gmx.net>    <1190115011.2995.126.camel@chaos> <59750.145.64.134.222.1190121239.squirrel@www.hardeman.nu>
In-Reply-To: <59750.145.64.134.222.1190121239.squirrel@www.hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Härdeman wrote:
> On Tue, September 18, 2007 13:30, Thomas Gleixner wrote:
>>>>         timer_gettime(fd | POSIX_TIMER_FD, .....);
>> If we use the most significant bit for POSIX_TIMER_FD, we should be
>> fine.
> 
> I think alternative b) - three new syscalls, sounds better.
> 
> The only negatives so far are that it adds more syscalls and that it might
> require code duplication with posix timers. The syscall numbers argument
> seemed not to be very important and the code duplication should be fixable
> by refactoring the code so that more is shared between the two systems (I
> assume).

Yes, I'm inclined to agree with you on both points.

> Overloading file descriptors with flags looks ugly, is there any other
> syscall which does that?

AFAIK there is no other syscall that does that.  I agree that it's not very
pretty.

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

