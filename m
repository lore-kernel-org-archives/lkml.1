Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbXHGG44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbXHGG44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXHGG4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:56:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:38486 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753436AbXHGG4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:56:47 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18IVGQGMPEI6DdS0Sp8LpwTDGwgZuRB/uToK8xfNg
	PecHaFODefv+0p
Message-ID: <46B81745.9010409@gmx.net>
Date: Tue, 07 Aug 2007 08:55:01 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org, Christoph Hellwig <hch@lst.de>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Problems with timerfd()
References: <46A44B7D.3030700@gmx.net>	<20070722233826.20efa6e5.akpm@linux-foundation.org>	<46A7940B.4070901@gmx.net> <20070725151252.8d2d5141.akpm@linux-foundation.org>
In-Reply-To: <20070725151252.8d2d5141.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I'm working on the changes to timerfd(), but must admit I am struggling to
understand some of the kernel code for working with userspace timers (e.g.,
in kernel/posix-timers.c).  Can you suggest anyone who could provide
assistance?

Cheers,

Michael

Andrew Morton wrote:
> On Wed, 25 Jul 2007 20:18:51 +0200
> Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> 
>> Andrew,
>>
>> Andrew Morton wrote:
>>> On Mon, 23 Jul 2007 08:32:29 +0200 Michael Kerrisk <mtk-manpages@gmx.net> wrote:
>>>
>>>> Andrew,
>>>>
>>>> The timerfd() syscall went into 2.6.22.  While writing the man page for
>>>> this syscall I've found some notable limitations of the interface, and I am
>>>> wondering whether you and Linus would consider having this interface fixed
>>>> for 2.6.23.
>>>>
>>>> On the one hand, these fixes would be an ABI change, which is of course
>>>> bad.  (However, as noted below, you have already accepted one of the ABI
>>>> changes that I suggested into -mm, after Davide submitted a patch.)
>>>>
>>>> On the other hand, the interface has not yet made its way into a glibc
>>>> release, and the change will not break applications.  (The 2.6.22 version
>>>> of the interface would just be "broken".)
>>> I think if the need is sufficient we can do this: fix it in 2.6.23 and in
>>> 2.6.22.x.  That means that there will be a few broken-on-new-glibc kernels
>>> out in the wild, but very few I suspect.
>> So I'm still not quite clear.  Can I take it from your statement above that
>> the proposed ABI changes would be admissible, as long as Davide is okay
>> with them?
>>
> 
> yup, I'll send that diff into Linus and -stable and see what happens.
> 

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
