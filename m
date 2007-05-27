Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbXE0VBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbXE0VBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbXE0VAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:00:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2056 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756860AbXE0VA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:00:29 -0400
Date: Sun, 27 May 2007 20:39:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       Julian Sikorski <belegdol@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH} x86_64 PM_TRACE support.
Message-ID: <20070527203955.GE3989@ucw.cz>
References: <1180161174.9773.60.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180161174.9773.60.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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

ia64? did you mean x86-64?

Otherwise looks ok to me.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
