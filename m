Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbXCMVvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbXCMVvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933745AbXCMVvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:51:02 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:38150 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740AbXCMVvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:51:01 -0400
Date: Tue, 13 Mar 2007 14:45:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [RFC/PATCH 00/59] Make common x86 arch area for i386 and x86_64
Message-ID: <20070313214512.GM10574@sequoia.sous-sol.org>
References: <1173820919.28042.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173820919.28042.3.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> Recently I've been doing some work that will affect both the i386 and x86_64
> architectures.  So there will be common code for both, as well as code
> that will be unique for the specific arch.  So I was looking into a way
> to do this cleanly, and found that there is no clean way to share code
> between x86_64 and i386.

Thanks for taking this on.  I'm sure Andi has a bunch of ideas on this
topic, but it would be nice to see the consolidation.

> So the move patches are a simple move of one file, with the slight exception 
> of files that hold the speedstep-lib.h file.  This file was moved from the
> arch/i386/kerne/cpu/cpufreq directory and put into the include/asm-i386
> directory.  This was due to the fact that some of the moved files included
> it, and some files that were not moved also included it. Instead of using
> the #include "../../x86/" hack again, I just simply moved it to the global
> i386 include directory.  Only the arch/x86 will use the include/asm-i386

what about asm-x86/ dir?  the asm/ symlink would still point to relevant
arch, but the file there could be simply #include <asm-x86/file.h> ?

thanks,
-chris
