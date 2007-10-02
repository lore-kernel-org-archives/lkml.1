Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbXJBWwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbXJBWwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXJBWvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:51:53 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:43371 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbXJBWvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:51:52 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Date: Tue, 2 Oct 2007 23:51:48 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2064
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710022351.48971.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 04:41:49 Linus Torvalds wrote:
[snip]
> In other words, people who know they may be affected and would want to
> prepare can look at (for example)
>
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git x86
>
> and generally get ready for the switch-over.

This is certainly a tool issue, but if I use Debian's kernel-image "make-kpkg" 
wrapper around the kernel build system, it fails with:

cp: cannot stat `arch/x86_64/boot/bzImage': No such file or directory

Obviously, this file has moved to arch/x86/boot, but it seems like possibly 
unnecessary breakage. I've been copying bzImage for years from 
arch/x86_64/boot, and I'm sure there's a handful of scripts (other than 
Debian's kernel-image) doing this too.

For now, I hacked the tool[1]. Maybe, if we care, a symlink could be set up 
between arch/x86/boot and arch/$ARCH/boot ? Or would papering over this be 
more trouble than it's worth?

[1] http://devzero.co.uk/~alistair/kernel-package-changes.diff

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

