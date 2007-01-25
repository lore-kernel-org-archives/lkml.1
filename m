Return-Path: <linux-kernel-owner+w=401wt.eu-S965738AbXAYJce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738AbXAYJce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965737AbXAYJce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:32:34 -0500
Received: from raven.upol.cz ([158.194.120.4]:35510 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965739AbXAYJcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:32:33 -0500
Date: Thu, 25 Jan 2007 09:40:51 +0000
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Message-ID: <20070125094051.GA9725@flower.upol.cz>
References: <200701151624.18033.rob@landley.net> <200701241230.40996.rob@landley.net> <E1H9pHf-0002Iu-4D@flower> <200701242051.34153.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701242051.34153.rob@landley.net>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 08:51:32PM -0500, Rob Landley wrote:
> On Wednesday 24 January 2007 4:03 pm, Oleg Verych wrote:
> 
> > Let me propose you to test this as solution, that need no awk, only shell:
> 
> Actually awk is one of the standard Single Unix Specification (version 3) 
> utilities and the kernel build uses it in a number of places, such as 
> arch/alpha/boot/Makefile, drivers/eisa/Makefile, scripts/ver_linux.

I saw that. If you will test my first replacements and it will be ok,
i will go to this.

> Your objection is a bit like saying "and don't use cat".  I'm saying don't 
> call cat "gcat" when you just mean plain old cat.

No it's not, really. I don't want to see pipes, fork()s, disk seek,
when task can be done without it. I know, what awk is, and i hope it
will have its better time.

> > p.s. who is going to make alternative to GNU make ? ;D
> 
> Me.  Seriously.  It's on my todo list, as part of the Firmware Linux project:

Well. I didn't expect such answer! So, after my trying to deal with
makefiles (there so many to cleanup and structure), i think it will be
easy to do so. I did contacted (ft)jam developers, but didn't get any
answer on current state of it vs GNU make.

> http://lwn.net/Articles/215941/
> 
> Although as major projects go, it's about fifth down on the list after getting 
> toybox up to speed, writing a proper bash replacement shell, getting tcc to 
> build an unmodified Linux kernel, convincing the uClibc guys to HAVE ANOTHER 
> RELEASE ALREADY (it's been a year and a half, I _sent_ a cake)...

Thanks for information.

> Today, I'm writing a gene2fs that produces streaming output (I.E. it works 
> like tar).  It's not done yet...

Good luck !

____
