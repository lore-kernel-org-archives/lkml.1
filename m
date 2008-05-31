Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYEaT04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYEaT04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYEaT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 15:26:46 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:51366 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYEaT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 15:26:45 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 May 2008 15:26:45 EDT
Date: Sat, 31 May 2008 21:21:21 +0200
From: Lars Noschinski <lars@public.noschinski.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080531192120.GA6843@lars.home.noschinski.de>
References: <1212010931.3445.103.camel@localhost.localdomain> <1212013125.2236.58.camel@shinybook.infradead.org> <1212014127.3445.115.camel@localhost.localdomain> <20080528.230934.131215087.davem@davemloft.net> <1212071813.3428.22.camel@localhost.localdomain> <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz>
User-Agent: mutt-ng/devel-r804 (Linux)
X-Df-Sender: 336680
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Kosina <jkosina@suse.cz> [08-05-31 11:48]:
>I fully agree, but my impression is that this really is not going to be 
>easy. Fixing bugs definitely is a good way to start kernel coding -- it 
>forces you to understand the internals of the source, get used to the 
>coding style by reading the code, etc. Unfortunately, it's simply not very 
>attractive for newcomers.
>
>For example -- I am leading a seminar at university, oriented at linux 
>kernel internals. I provide the possibility to students either to
>
>- write some stand-alone interesting kernel project
>- fix a few non-trivial bugs in kernel bugzilla
>- chose any part of a kernel, learn how it works, and present this to 
>  other seminar attendees
>
>The feedback I often get from students (and these guys are studying 
>computer science) is
>
>- writing some wholy new interesting kernel project is usually too 
>  complicated (both coming with an interesting idea for a project, and 
>  doing the coding itself)
>- fixing random bugs from kernel bugzilla is boring (spending 10 hours 
>  looking for missing '=' doesn't really attract them)
>
>So in overwhelming majority of cases, they just chose the presentation.

 From my own experience: Last semester, I participated in a "Linux Kernel
Hacking Lab" which involved some smaller tasks (write a module which
presents a circular buffer in /proc; the same as char device; write
a very minimalistic file system, extend it to do something resembling
journalling, ...) and a larger project.

The first two tasks were easily done by reading Linux Device Drivers;
but after the file system task (2 weeks), more than half of the group
dropped out; probably because to get this task done you needed to dig at
least in the minix code.

The project I was later involved on was writing a file system, which
stores blocks with the same content only once. In a two months period
(with other lectures to attend to), we managed to produce such a thing;
but it was very unreliable (which reminds me, I am supposed to publish
the results of this project here)

Most problems resulted of a combination of not enough documentation
(filesystem/page cache/block device interaction) and "not digging deep
enough, so the kernel does not really do what we expected".

So, the code produced in this learning phase is not usable; but I
learned a lot from this. Restarting from scratch now would probably
yield some working code.

At least, know I understand why Linux has such a high rate of changes ;)

>All I want to say is that I could very well imagine that a lot of 
>newcomers will find "hey, feel free to crawl through bugzilla and fix 
>whatever you are able to fix" very non-attractive.
>Not that I have any better idea right now, though.

I probably would not have attended a lab titled like this ;)
