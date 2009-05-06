Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZEFE6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZEFE6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZEFE6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:58:11 -0400
Received: from www.sr71.net ([198.145.64.142]:49495 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZEFE6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:58:09 -0400
Subject: Re: 2.6.30-rc2 soft lockups: ACPI?  clock source problem?
From: Dave Hansen <dave@sr71.net>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, lenb@kernel.org
In-Reply-To: <1240513827.7224.2.camel@localhost.localdomain>
References: <1240335038.11194.11.camel@nimitz>
	 <20090422204557.10c3cc37.akpm@linux-foundation.org>
	 <1240511508.10627.159.camel@nimitz>
	 <1240513827.7224.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 05 May 2009 21:58:08 -0700
Message-Id: <1241585888.8010.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-23 at 12:10 -0700, john stultz wrote:
> On Thu, 2009-04-23 at 11:31 -0700, Dave Hansen wrote:
> > On Wed, 2009-04-22 at 20:45 -0700, Andrew Morton wrote:
> > > (Is jstultz@us.ibm.com correct?)
> > 
> > Only I want it to go to the black hole which is Lotus Notes. :)
> > 
> > > On Tue, 21 Apr 2009 10:30:38 -0700 Dave Hansen <dave@sr71.net> wrote:
> > > > This was during my first boot of 2.6.30-rc2.
> > > 
> > > Did it ever happen again?
> > 
> > I've seen it on three different boots, but the stack traces were a bit
> > different each time.  So, I assume it is a true timekeeping thing
> > instead of something *actually* locking up.
> > 
> > > I assume this is a post-2.6.29 regression?  (Yet another.  We've been
> > > extra bad this time)
> > 
> > This laptop has been quite good to me and I haven't rebooted since the
> > late 2.6.28 days.  It isn't anything special, though.  Just a Lenovo
> > T61.  I wonder if my .config is a bit different.
> 
> I've got a T61 at home, so I'll try to test it out. Dave, can you send
> me your .config? Also any chance you can bisect this down a tiny bit?

OK, so I got back to this.  It's actually fixed in -rc4!  I assume it
was something in the ACPI merge that happened after -rc3.

I did check that the clocksource was set as the hpet in all cases both
before and after I saw the cpu lockup warning and on the good versions
of the kernel.

I can still go back and bisect it if anyone thinks that would be
valuable.

-- Dave

