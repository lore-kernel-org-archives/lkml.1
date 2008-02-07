Return-Path: <linux-kernel-owner+w=401wt.eu-S935104AbYBGWyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104AbYBGWyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbYBGWy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:54:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759337AbYBGWy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:54:28 -0500
Date: Thu, 7 Feb 2008 14:53:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: akpm@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       tony@bakeyournoodle.com
Subject: Re: [PATCH] Fix compilation of powerpc asm-offsets.c with old gcc
In-Reply-To: <18347.34100.60973.215093@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.1.00.0802071449240.2896@woody.linux-foundation.org>
References: <18347.34100.60973.215093@cargo.ozlabs.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Feb 2008, Paul Mackerras wrote:
>
> From: Tony Breeds <tony@bakeyournoodle.com>
> 
> Commit ad7f71674ad7c3c4467e48f6ab9e85516dae2720 corrected the clock
> ..

Please, when mentioning hex numbers, also do the one-liner shortlog.

I realize that in gitk (or even just with two terminal windows open and a 
git repository) it's trivial to just follow the link and see what that 
commit was, but even you're just doing a "git log" or more commonly if you 
read the commit log somewhere else (like a mail gateway that posts them 
automatically when I apply things), it's really much more readable if you 
were to say something like:

  Commit ad7f71674ad7c3c4467e48f6ab9e85516dae2720 ("[POWERPC] Use a 
  sensible default for clock_getres() in the VDSO") corrected the clock
  ...

which reads much mroe naturally without having to go wonder what that 
commit was doing. No?

As it is, I'm pretty used to editing those things in (I do it all the 
time), and I will do so for this email too, but I want to keep bringing 
this up so that I hopfully wouldn't have to do it so often. So please 
write your commit messages with the specific git information available, 
but without _requiring_ people to be git users to get the gist of the 
matter, ok?

			Linus
