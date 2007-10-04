Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXJDRXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXJDRXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbXJDRXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:23:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40199 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXJDRX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:23:29 -0400
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>
Cc: Ollie Wild <aaw@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <m3wsu2u7y6.fsf@bigip.mine.nu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	 <m3wsu2u7y6.fsf@bigip.mine.nu>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 19:17:50 +0200
Message-Id: <1191518270.5574.21.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-04 at 19:05 +0200, Mathieu Chouquet-Stringer wrote:
> Hey there,
> 
> I've seen the changes you made in commit b6a2fea39318 and I guess they
> might be responsible for my xargs breakage...
> 
> In the kernel source tree, if I run a stupid find | xargs ls, I now get
> this:
> xargs: ls: Argument list too long

/me tries

yep works like a charm, and that is a tree with a full git repo and
several build dirs in it.

> Which is kind of annoying but I can work around it though make distclean in
> my kernel tree dies with the same symptom (aka -E2BIG).
> 
> I run a vanilla 2.6.23-rc9 (Linux version 2.6.23-rc9 (mchouque@shookaylt)
> (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #1 Tue Oct 2 08:13:47 EDT
> 2007) on FC7...
> 
> Let me know if I can do anything.  I'm going to try to bisect the problem
> after I recompile the kernel without this patch...

what happens if you up the stack limit to say 128M ?

Also, do you happen to have execve syscall audit stuff enabled?

