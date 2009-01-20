Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbZATQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbZATQMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 11:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbZATQMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 11:12:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:58122 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755870AbZATQMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:12:07 -0500
Date: Tue, 20 Jan 2009 17:12:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove byte locks
In-Reply-To: <20090115105808.GA16253@elte.hu>
Message-ID: <alpine.LNX.1.10.0901201709470.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901121247430.5377@jikos.suse.cz> <20090112120743.GC24266@elte.hu> <alpine.LNX.1.10.0901121334510.5377@jikos.suse.cz> <20090112124401.GA31939@elte.hu> <496D1F54.7070104@goop.org> <alpine.LNX.1.10.0901140016520.5377@jikos.suse.cz>
 <496D292B.20007@goop.org> <alpine.LNX.1.10.0901151147420.5377@jikos.suse.cz> <20090115105808.GA16253@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Ingo Molnar wrote:

> > > > Why can't this just be somewhere in documentation? (possibly even with 
> > > > the byte locks code as a reference).
> > > Because Ingo's compil-o-matic will never fail on a documentation error.
> > 
> > Hmm, I have always considered the "we don't accept any code that would 
> > have zero in-kernel users" rule as a quite reasonable one, at least in 
> > order to prevent from bloat and code getting confusing.
> > But apparently it's not the intention here.
> > 
> > > > It is IMHO just totally confusing to have a spinlock implementation that is
> > > > not used at all in the tree. It took me quite some time to go through this
> > > > until I finally figured out that this code is actually never used.
> > > > Currently, on first sight it might seem that byte locks are used whenever
> > > > CONFIG_PARAVIRT is set, which is not true.
> > > Well, a comment next to the code explaining the rationale probably 
> > > wouldn't go astray.
> > 
> > I still strongly feel that if the only purpose of the code in kernel is 
> > "to provide example", then it belongs to documentation.
> > 
> > > > And apparently even Linus got confused by this, which also tells us
> > > > something by itself, see [1].
> > > > [1] http://marc.info/?l=linux-kernel&m=123144211719754&w=2
> > > It tells us that Linus couldn't give a rat's arse about virtualization, 
> > > which is just something we have to cope with ;)
> > 
> > I am afraid this has nothing to do with virtualization. It's simply 
> > confusing when looking at the code.
> 
> i'd tend to agree, that area of code is quite complex already.

ping, any final word here? Should I consider the silence a implicit nak, 
or should I resend the patch?

-- 
Jiri Kosina
