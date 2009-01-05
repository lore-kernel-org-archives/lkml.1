Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZAEWOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZAEWOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZAEWOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:14:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbZAEWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:14:24 -0500
Date: Mon, 5 Jan 2009 17:14:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
In-Reply-To: <20090105220156.GC8592@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0901051710450.25066@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <20090105195415.GA6204@uranus.ravnborg.org> <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com> <20090105213107.GA27293@uranus.ravnborg.org>
 <alpine.DEB.1.10.0901051649240.25066@gandalf.stny.rr.com> <20090105220156.GC8592@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 Jan 2009, Sam Ravnborg wrote:

> > Is this all sparc cross compiler?  I'm trying to reproduce it on x86 with 
> > no avail :-(
> > 
> > I would like to test other ways to change the macro, but to do so, I need 
> > to get a compiler that will produce the warnings that you see. What 
> > version of gcc are you using?
> 
> I used crosstool to build a 3.4.5 gcc:

Hmm, that's a pretty old compiler. I wonder if it wouldn't just help
if we just make the branch tracer dependent on the compiler used. That is.

#if defined(CONFIG_PROFILE_ALL_BRANCHES) && (__GNUC__ >= 4)
#define if(cond) ...

Or something :-/

-- Steve
