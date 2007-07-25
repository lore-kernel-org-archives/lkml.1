Return-Path: <linux-kernel-owner+w=401wt.eu-S934742AbXGYSUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742AbXGYSUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765687AbXGYSUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:20:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:54433 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1765785AbXGYSUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:20:30 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+9WE4lhqu9pCLz4112FMI6xsRZ7K1LJPPso5LEhS
	sTmbOFqQXy7je3
Message-ID: <46A7940B.4070901@gmx.net>
Date: Wed, 25 Jul 2007 20:18:51 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org
Subject: Re: Problems with timerfd()
References: <46A44B7D.3030700@gmx.net> <20070722233826.20efa6e5.akpm@linux-foundation.org>
In-Reply-To: <20070722233826.20efa6e5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Andrew Morton wrote:
> On Mon, 23 Jul 2007 08:32:29 +0200 Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> 
>> Andrew,
>>
>> The timerfd() syscall went into 2.6.22.  While writing the man page for
>> this syscall I've found some notable limitations of the interface, and I am
>> wondering whether you and Linus would consider having this interface fixed
>> for 2.6.23.
>>
>> On the one hand, these fixes would be an ABI change, which is of course
>> bad.  (However, as noted below, you have already accepted one of the ABI
>> changes that I suggested into -mm, after Davide submitted a patch.)
>>
>> On the other hand, the interface has not yet made its way into a glibc
>> release, and the change will not break applications.  (The 2.6.22 version
>> of the interface would just be "broken".)
> 
> I think if the need is sufficient we can do this: fix it in 2.6.23 and in
> 2.6.22.x.  That means that there will be a few broken-on-new-glibc kernels
> out in the wild, but very few I suspect.

So I'm still not quite clear.  Can I take it from your statement above that
the proposed ABI changes would be admissible, as long as Davide is okay
with them?

Cheers,

Michael


-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
