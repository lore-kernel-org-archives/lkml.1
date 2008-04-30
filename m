Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbYD3U74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbYD3U74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbYD3U7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:59:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbYD3U7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:59:44 -0400
Date: Wed, 30 Apr 2008 13:59:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Noe <dpn@isomerica.net>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430135938.82e46e67.akpm@linux-foundation.org>
In-Reply-To: <4818DAC4.0@isomerica.net>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<4818DAC4.0@isomerica.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 16:47:00 -0400
Dan Noe <dpn@isomerica.net> wrote:

> On 4/30/2008 16:31, Linus Torvalds wrote:
> > 
> > On Wed, 30 Apr 2008, Andrew Morton wrote:
> >> <jumps up and down>
> >>
> >> There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
> > 
> > The problem I see with both -mm and linux-next is that they tend to be 
> > better at finding the "physical conflict" kind of issues (ie the merge 
> > itself fails) than the "code looks ok but doesn't actually work" kind of 
> > issue.
> > 
> > Why?
> > 
> > The tester base is simply too small.
> > 
> > Now, if *that* could be improved, that would be wonderful, but I'm not 
> > seeing it as very likely.
> 
> Perhaps we should be clear and simple about what potential testers 
> should be running at any given point in time.  With -mm, linux-next, 
> linux-2.6, etc, as a newcomer I find it difficult to know where my 
> testing time and energy is best directed.

-mm consists of the sum of

a) the ~80 subsytem maintainers trees (git and quilt)

b) the ~100 subsytem trees which are hosted only in -mm.


linux-next consists of only a)

Soon I shall remove a) from -mm and will replace it with linux-next (this
should be a no-op).

Later, I shall start feeding those 100 random subsystems into linux-next
as well (somehow).

> Is linux-next the right thing to be running at this point?

yes.  85% of the code which goes into Linux goes via the ~80 subsystem
maintainers' trees and is (or should be) in linux-next.  The other 15%
is the hosted-in-mm work.

>  Is there a 
> need for testing in a particular tree (netdev, x86, etc)?

No, please test the sum-of-all-trees in linux-next.  If you hit problems
then, as part of the problem resolving process a developer _might_ ask you
to test one tree specifically, but that would be a pretty unusual
circumstance.
