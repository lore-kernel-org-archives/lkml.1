Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZHaQac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZHaQac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 12:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZHaQab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 12:30:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48076 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZHaQab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 12:30:31 -0400
Message-ID: <4A9BFA92.2030300@us.ibm.com>
Date: Mon, 31 Aug 2009 09:30:10 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Michael Schnell <mschnell@lumino.de>, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>, Thomas Chou <thomas@wytron.com.tw>
Subject: Re: implementing Futex
References: <4A842B32.5030401@lumino.de> <200908141438.01392.arnd@arndb.de> <4A855EE5.9010105@lumino.de> <200908141533.16714.arnd@arndb.de>
In-Reply-To: <200908141533.16714.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 14 August 2009, Michael Schnell wrote:
>> Arnd Bergmann wrote:
>>> The man page says that the last parameter is ignored for op=FUTEX_WAKE,
>>> which is correct. The code that you were looking at however is for
>>> of=FUTEX_WAKE_OP, which is not documented as of manpages-3.22.
>>>
>>> It was added by Jakub back in 2005, but if he wrote a documentation
>>> for it, it never went into the man pages package. On a similar
>>> note, Ingo also added other futex operations that are not documented
>>> yet.
>>>
>> Thus in any documented software, the quite complex stuff in
>> "futex_atomic_op_inuser", which is provided in several different
>> "futex.h" files for all those architectures never is used ?
> 
> No, my point was that futex_atomic_op_inuser is indeed used
> correctly, it's just not documented.
> See http://lwn.net/Articles/148830/ for the initial posting
> 
>> Is there any viable use for this ?
> 
> glibc heavily uses it for the pthreads implementation.
> 
>> Would it not be appropriate either to do a documentation or to remove it ?
> 
> Adding documentation, yes.

I also recently added two futex op codes which need to be added to the 
man page, but they are documented in Documentation/futex-requeue-pi.txt. 
   Documentation/pi-futex.txt documents the FUTEX_(UN)LOCK_PI opcodes 
which aren't in the man pages either.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
