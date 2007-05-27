Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbXE0VrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbXE0VrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759609AbXE0Vqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:46:50 -0400
Received: from xenotime.net ([66.160.160.81]:42395 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759547AbXE0Vqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:46:49 -0400
Date: Sun, 27 May 2007 14:53:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: nigel@nigel.suspend2.net
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       Julian Sikorski <belegdol@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH} x86_64 PM_TRACE support.
Message-Id: <20070527145326.b42c9376.rdunlap@xenotime.net>
In-Reply-To: <1180161174.9773.60.camel@nigel.suspend2.net>
References: <1180161174.9773.60.camel@nigel.suspend2.net>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007 16:32:54 +1000 Nigel Cunningham wrote:

> Hi all.
> 
> As promised I took another look at the patch and at what Randy had
> prepared to fix the IA64 compilation error. I did some more work on it,
> and believe that the following is the tidiest correct solution I can
> come up with. It differs from the version that caused the compilation
> error primarily in that:
> 
> * the #include <asm/resume-trace.h> is inside the #ifdef 
>   CONFIG_PM_TRACE.
> * now-unnecessary protection for multiple #includes and ifdef testing of
>   CONFIG_PM_TRACE in the asm code were removed.
> * do-nothing definitions for !PM_TRACE restored to
>   include/linux/resume-trace.h.
> 
> We're therefore depending upon kernel/power/Kconfig having the right
> depends condition. As far as I can see, IA64 doesn't define CONFIG_X86.
> Is that correct, or do we need to have (X86 && !IA64)?

Correct, X86 is i386 and x86_64.  Not IA64.

> Randy, since this is substantially different to the work you did, I
> haven't added your signed-off-by as we previously discussed.

OK.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
