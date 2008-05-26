Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYEZJjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYEZJjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYEZJje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:39:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbYEZJjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:39:33 -0400
Date: Mon, 26 May 2008 11:39:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@linux.intel.com>,
       Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526093913.GG13529@elte.hu>
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080524224554.GA5970@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@MIT.EDU> wrote:

> On Sat, May 24, 2008 at 03:30:20PM -0700, Arjan van de Ven wrote:
> > 
> > Ted looked at these during the LF summit, and his conclusion was 
> > that they're all media errors (eg USB unplug) that ext3 then did not 
> > handle well at all. Maybe Ted has an update on this?
> 
> Not really.  It's on my todo list but fixing a bug caused by users 
> doing something stupid (pulling a mounted USB stick) has been lower 
> than a number of other fires burning on my plate.  I'll try to get to 
> it but a lot of other things I need to worry about have deadlines 
> associated with them....

Exactly why is pulling an USB stick considered "stupid"? Last i checked 
there was no physical lock preventing users from doing that.

Sure, pulling a mounted USB stick is inconvenient ... for _us_ kernel 
developers. But the user really doesnt care and shouldnt care.

	Ingo
