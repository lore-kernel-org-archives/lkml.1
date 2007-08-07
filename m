Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbXHGJP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbXHGJP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbXHGJPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:15:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:33524 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758470AbXHGJPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:15:00 -0400
Cc: Thomas Gleixner <tglx@linutronix.de>, rdunlap@xenotime.net, hch@lst.de,
       stable@kernel.org, drepper@redhat.com, davidel@xmailserver.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 07 Aug 2007 11:14:58 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <20070807003613.f0333b49.akpm@linux-foundation.org>
Message-ID: <20070807091458.23920@gmx.net>
MIME-Version: 1.0
References: <46A44B7D.3030700@gmx.net>
	<20070722233826.20efa6e5.akpm@linux-foundation.org>
	<46A7940B.4070901@gmx.net>
	<20070725151252.8d2d5141.akpm@linux-foundation.org>
	<46B81745.9010409@gmx.net> <20070807003613.f0333b49.akpm@linux-foundation.org>
Subject: Re: Problems with timerfd()
To: Andrew Morton <akpm@linux-foundation.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX187JRpXmQQ7UeXdVeIqLf8m24tbVNfzAdflnwDYOI
 ztxfDl+YxbxyMf2ypWigzykN1ujwhzBqmGUQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: KgqBc2NEeWUoKc7+CHRzGEAxU3U4N09R
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 07 Aug 2007 08:55:01 +0200 Michael Kerrisk <mtk-manpages@gmx.net>
> wrote:
> 
> > I'm working on the changes to timerfd(), but must admit I am struggling
> > to understand some of the kernel code for working with userspace timers
> > (e.g., in kernel/posix-timers.c).
> 
> Join the club.

Ahhh good to know I'm not the only one challeged by the code.

> >  Can you suggest anyone who could provide assistance?
> 
> The code was originally contributed by George Anzinger.  

Yes, I pinged George a week or so back, but got no response.
(I think he's more or less retired nowadays.)

> He has moved on
> and Thomas Gleixner now does most work in there.  I'd expect that Thomas
> is
> your guy, but he is nearing the end of a two-week vacation and will
> presumably return to an akpm-sized inbox, so I'd give him a little time 
> ;)

Thanks -- Thomas CCed on this reply.

Unfortunately I myself go on holiday on Saturday for two weeks.
All of these holidays (I guess that Davide is only back in another
1.5 weeks or so) start to make the chances of getting change
in during the .23-rc window look tight...

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

