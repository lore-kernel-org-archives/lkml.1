Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZIVQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZIVQM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZIVQM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:12:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbZIVQMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:12:25 -0400
Subject: Re: fanotify as syscalls
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Jamie Lokier <jamie@shareable.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, alan@linux.intel.com, hch@infradead.org
In-Reply-To: <200909221731.34717.agruen@suse.de>
References: <20090912094110.GB24709@ioremap.net>
	 <20090921231227.GJ14700@shareable.org>
	 <alpine.DEB.2.00.0909211816020.1116@makko.or.mcafeemobile.com>
	 <200909221731.34717.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Sep 2009 12:11:58 -0400
Message-Id: <1253635918.2747.5.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 17:31 +0200, Andreas Gruenbacher wrote:
> On Tuesday, 22 September 2009 16:51:39 Davide Libenzi wrote:
> > On Tue, 22 Sep 2009, Jamie Lokier wrote:
> > > I don't mind at all if fanotify is replaced by a general purpose "take
> > > over the system call table" solution ...
> >
> > That was not what I meant ;)
> > You'd register/unregister as syscall interceptor, receiving syscall number
> > and parameters, you'd be able to return status/error codes directly, and
> > you'd have the ability to eventually change the parameters. All this
> > should be pretty trivial code, and at the same time give full syscall
> > visibility to the modules.
> 
> The fatal flaw of syscall interception is race conditions: 

That's not the fatal flaw.  The fatal flaw is that I am not going to
write 90% of a rootkit and make it easy to use.  Not going to happen.
There's a reason we went to the trouble to mark the syscall call RO, we
don't export it, and we don't want people playing with it.  It clearly
would have been the quickest, easiest, and fastest way to make
anti-virus companies happy, but it doesn't really solve a good problem
and it leaves all of us in a worse position than we are today.  Easy !=
Good.

-Eric 

