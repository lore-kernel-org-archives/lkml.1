Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbXEaALM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbXEaALM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXEaAK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:10:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51828 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXEaAK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:10:56 -0400
Date: Wed, 30 May 2007 17:09:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       Julian Sikorski <belegdol@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH} x86_64 PM_TRACE support.
Message-Id: <20070530170921.e793a34f.randy.dunlap@oracle.com>
In-Reply-To: <20070531000133.GE2794@redhat.com>
References: <1180161174.9773.60.camel@nigel.suspend2.net>
	<20070531000133.GE2794@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 20:01:34 -0400 Dave Jones wrote:

> On Sat, May 26, 2007 at 04:32:54PM +1000, Nigel Cunningham wrote:
> 
> Hi Nigel,
> 
>  > As promised I took another look at the patch and at what Randy had
>  > prepared to fix the IA64 compilation error. I did some more work on it,
>  > and believe that the following is the tidiest correct solution I can
>  > come up with. It differs from the version that caused the compilation
>  > error primarily in that:
>  > 
>  > * the #include <asm/resume-trace.h> is inside the #ifdef 
>  >   CONFIG_PM_TRACE.
>  > * now-unnecessary protection for multiple #includes and ifdef testing of
>  >   CONFIG_PM_TRACE in the asm code were removed.
>  > * do-nothing definitions for !PM_TRACE restored to
>  >   include/linux/resume-trace.h.
>  > 
>  > We're therefore depending upon kernel/power/Kconfig having the right
>  > depends condition. As far as I can see, IA64 doesn't define CONFIG_X86.
>  > Is that correct, or do we need to have (X86 && !IA64)?
> 
> Can you post a copy of this that isn't mangled by quoted-printable encoding?
> Whilst it looks fine in my MUA, the diff ends up looking like..

yep :(

http://www.xenotime.net/linux/patches/x8664-pm-trace-support.patch

in case Nigel is asleep.


> I'm beginning to think we really need a Documentation/Unhorking-MUAs-HOWTO
> judging by the amount of broken encodings we seem to get to lkml these days.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
