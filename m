Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYHVUeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYHVUeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYHVUeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:34:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45762 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbYHVUeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:34:01 -0400
Date: Fri, 22 Aug 2008 16:33:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pavel Machek <pavel@suse.cz>
cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ftraced and suspend to ram
In-Reply-To: <20080822104610.GA3482@elf.ucw.cz>
Message-ID: <alpine.DEB.1.10.0808221632410.14231@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808211423410.678@gandalf.stny.rr.com> <200808212037.11775.rjw@sisk.pl> <200808212159.37678.rjw@sisk.pl> <20080822044649.GA356@elte.hu> <20080822072343.GA24173@atrey.karlin.mff.cuni.cz>
 <20080822103533.GA5425@joi> <20080822104610.GA3482@elf.ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 22 Aug 2008, Pavel Machek wrote:
> 
> Does ftrace hook itself onto _all_ the functions? Or all .c functions?

It hooks into all .c functions that are not annotated with "notrace"
or the files have not been marked in the Makefile like:

  CFLAGS_REMOVE_<file>.o = -pg


> 
> I guess low-level suspend code needs to be exempt from
> tracing. Certainly all the assembly functions.

I'm looking into that now too. Are the functions in arch/x86/power/cpu*.c 
the suspend to ram code?

Thanks,

-- Steve

