Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbZFLKUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbZFLKUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759622AbZFLKUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:20:10 -0400
Received: from lazybastard.de ([212.112.238.170]:54395 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbZFLKUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:20:09 -0400
Date: Fri, 12 Jun 2009 12:19:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090612101934.GA31508@logfs.org>
References: <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com> <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet> <20090611215941.GA14053@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090611215941.GA14053@goodmis.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 June 2009 17:59:41 -0400, Steven Rostedt wrote:
> 
> The tools you mentioned
> 
>   "ip, iw, rfkill, crda, the WiMAX"
> 
> I have no idea what they do.

ip I can explain to you.  Ten years back when I was a netadmin I faced
the problem of implementing traffic shaping of some sorts.  Details
don't matter much.  After a very short while I learned that ip was the
solution to my problem.  One week later I started digging into the
kernel code because I simply couldn't work out how to use this thing.  
Another week later I was playing with the idea of writing my own traffic
shaper in the kernel instead.  It was that bad.

Then I found something called tinybsd, a bsd distro on one floppy disk.
We allotted an old 486 with two network cards, I spent some
uncomfortable time configuring the beast with the crappy editor you can
expect on 1.44MB and the thing just worked henceforth.

Oh, the bsd had their equivalent of ip tightly coupled with their
kernel.  Not sure if that caused the marked difference, but I'll gladly
add this shred of anecdotal support.

[ And in case someone takes offence or considers me an idiot for not
being able to use ip or tc, I would _love_ to see a howto explaining how
one can limit the amount of traffic on one interface to - say - 1GB per
month. ]

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
