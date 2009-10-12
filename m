Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbZJLAD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbZJLAD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 20:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZJLAD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 20:03:26 -0400
Received: from thunk.org ([69.25.196.29]:59255 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZJLADZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 20:03:25 -0400
Date: Sun, 11 Oct 2009 20:02:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, linux-ext4@vger.kernel.org
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
Message-ID: <20091012000212.GA21000@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>,
	linux-ext4@vger.kernel.org
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera> <alpine.LFD.2.01.0910111608490.3438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910111608490.3438@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 04:11:20PM -0700, Linus Torvalds wrote:
> 
> On Mon, 12 Oct 2009, Rafael J. Wysocki wrote:
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14370
> > Subject		: ext4 corruptions
> > Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> > Date		: 2009-10-09 19:20 (3 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125511643504864&w=4
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
> > Subject		: Bad corruption with 2.6.32-rc1 and upwards
> > Submitter	: Holger Freyther <zecke@selfish.org>
> > Date		: 2009-10-09 15:42 (3 days old)
> 
> These two look like duplicates to me. No?

I'm not sure.  I'm not able to replicate either failure.  According to
Holger, his failure happens after a clean shutdown.  Alexey's happens
after a crash/forced power down.  So they could possibly be two
separate failures --- although obviously I hope not!

However, Alexey has been posting his failure information in bug
#14354, so we might as well close #14370.  What I really need is hints
about how to replicate the failure.

						- Ted
