Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbZFKXUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbZFKXUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZFKXUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:20:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44247 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbZFKXUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:20:05 -0400
Date: Fri, 12 Jun 2009 00:19:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611231952.GX8633@ZenIV.linux.org.uk>
References: <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com> <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet> <20090611212635.GA9446@uranus.ravnborg.org> <4A3182C6.803@gmail.com> <alpine.LFD.2.01.0906111521210.3535@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111521210.3535@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 03:27:36PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 12 Jun 2009, Jiri Slaby wrote:
> > 
> > Bah, having 40M .src.rpm for a 5k binary package?
> 
> Why do people who don't even know how packaging works bother to even 
> participate in the discussion?
> 
> Look at how many git binary packages there are some day. For CVS users, 
> for SVN people, graphical tools etc. Do you think that each of them has a 
> source package?
> 
> No.
> 
> You can generate multiple binary packages from the same source package 
> (trivial example: debug builds etc). But you want to make a point, and 
> then YOU USE SOME DAMN IDIOTIC AND IGNORANT argument to do so.

Linus, the real question that needs to be answered is this:

	What shall be done to ABI-breaking changes when users of that ABI are
in tools/*?

_That_ is the real issue.  Because I can guarantee that there will be attempts
to use that as an excuse for ABI breakage.  We have one specimen in this
thread already, complete with "oh, bisect problems don't matter, just rebuild
all packages" (and install them where, exactly? if it, say, break-the-boot
kind of incompatibility, how does one recover from running into a b0rken
kernel during bisect?)

If you are willing to ban that kind of crap - great; there are real remaining
issues (mostly with choosing the dependencies between binary packages), but
that's more or less survivable.  If not... we'll have one hell of a PITA
to deal with when that kind of excuse gets actually used.
