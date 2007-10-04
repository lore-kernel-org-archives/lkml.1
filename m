Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXJDSA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXJDSA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbXJDSAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:00:19 -0400
Received: from mx1.lost-oasis.net ([212.85.153.8]:51047 "EHLO
	mx1.lost-oasis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbXJDSAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:00:17 -0400
X-Greylist: delayed 3265 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 14:00:17 EDT
To: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w 3:{EoxBR
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
Organization: Uh?
Date: Thu, 04 Oct 2007 19:05:05 +0200
In-Reply-To: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> (Linus Torvalds's message of "Mon\, 1 Oct 2007 20\:41\:49 -0700 \(PDT\)")
Message-ID: <m3wsu2u7y6.fsf@bigip.mine.nu>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

         Hey there,

I've seen the changes you made in commit b6a2fea39318 and I guess they
might be responsible for my xargs breakage...

In the kernel source tree, if I run a stupid find | xargs ls, I now get
this:
xargs: ls: Argument list too long

Which is kind of annoying but I can work around it though make distclean in
my kernel tree dies with the same symptom (aka -E2BIG).

I run a vanilla 2.6.23-rc9 (Linux version 2.6.23-rc9 (mchouque@shookaylt)
(gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #1 Tue Oct 2 08:13:47 EDT
2007) on FC7...

Let me know if I can do anything.  I'm going to try to bisect the problem
after I recompile the kernel without this patch...

Best,
Mathieu

torvalds@linux-foundation.org (Linus Torvalds) writes:
> I said I was hoping that -rc8 was the last -rc, and I hate doing this, but 
> we've had more changes since -rc8 than we had in -rc8. And while most of 
> them are pretty trivial, I really couldn't face doing a 2.6.23 release and 
> take the risk of some really stupid brown-paper-bag thing.
> [...]

-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
