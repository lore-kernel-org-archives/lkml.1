Return-Path: <linux-kernel-owner+w=401wt.eu-S935760AbYEBPpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935760AbYEBPpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759942AbYEBPpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:45:46 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:42740 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbYEBPpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:45:45 -0400
Date: Fri, 2 May 2008 12:44:06 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Paul Mackerras <paulus@samba.org>,
       Josh Boyer <jwboyer@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080502154406.GA6545@beyonder.ift.unesp.br>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@kernel.org>, Paul Mackerras <paulus@samba.org>,
	Josh Boyer <jwboyer@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Steven Rostedt <rostedt@goodmis.org>
References: <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi> <18458.30641.838156.434563@cargo.ozlabs.ibm.com> <1209697815.2946.156.camel@vader.jdub.homelinux.org> <18458.37891.268060.691285@cargo.ozlabs.ibm.com> <20080502082936.GB2003@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805020750220.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805020750220.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri  2.May'08 at  7:58:25 -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 2 May 2008, Adrian Bunk wrote:
> > 
> > But for users this is a recent regression since 2.6.24 worked
> > and 2.6.25 does not.
> 
> Totally and utterly immaterial.
> 
> If it's a timing-related bug, as far as developers are concerned, nothing 
> they did introduced the problem.
> 
> So anybody who think s that "process" should have caught it is just being 
> stupid. 

So I would like to ask you what an user should do when facing what is
probably a timing-related bug, as it appears I have the bad luck
of hitting one.

See for example my comments after this one 
http://bugzilla.kernel.org/show_bug.cgi?id=10117#c11

This same problem is still present with yesterday's git, and sometimes
it hangs without hpet=disable and sometimes it doesn't. (And never
with hpet=disable in the boot command line)

And when it hangs I can see only _one_ "Switched to high resolution mode
on CPU x" message before the hang point, and when it boots fine there
is always the two of them in sequence:

Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0

And using vga=6 or vga=0x0364 makes a difference in the probability
of hanging.

I am just waiting -rc1 to be released to send an email with my
problem again, as I am unable to debug this myself.
I think this is ok from my part, right?


