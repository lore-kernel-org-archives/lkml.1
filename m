Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbZEBPz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbZEBPz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbZEBPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:55:18 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:63853 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755272AbZEBPzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:55:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuIKAB8H/ElMQW1W/2dsb2JhbACBUJVvtg2COIFFBQ
Date: Sat, 2 May 2009 11:55:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pavel Machek <pavel@ucw.cz>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mark.langsdorf@amd.com, arekm@maven.pl,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090502155514.GA18847@Krystal>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.829846363@polymtl.ca> <20090425081914.GD2428@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090425081914.GD2428@ucw.cz>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:54:03 up 63 days, 12:20,  2 users,  load average: 0.31, 0.31,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@ucw.cz) wrote:
> On Wed 2009-04-22 16:18:54, Mathieu Desnoyers wrote:
> > http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/atomicops-internals-x86.cc
> > 
> > says
> > 
> > "  // Opteron Rev E has a bug in which on very rare occasions a locked
> >   // instruction doesn't act as a read-acquire barrier if followed by a
> >   // non-locked read-modify-write instruction.  Rev F has this bug in 
> >   // pre-release versions, but not in versions released to customers,
> >   // so we test only for Rev E, which is family 15, model 32..63 inclusive.
> 
> Could we be more careful  here and catch the F pre-release versions,
> too? Stepping should help there...
> 

Yes, I guess for F pre-releases we're stucked unless AMD provides more
information. Dtrace did not seem to bother about F pre-release versions
though, neither did Google.

Mathieu

> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
