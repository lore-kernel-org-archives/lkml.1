Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbXGKQcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbXGKQcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760266AbXGKQbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:31:52 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38749 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009AbXGKQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:31:50 -0400
Date: Wed, 11 Jul 2007 18:32:39 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070711163238.GD16703@enneenne.com>
References: <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <20070701171325.29d8b184.sfr@canb.auug.org.au> <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca> <20070710163625.GH32503@enneenne.com> <20070710220310.GI31193@csclub.uwaterloo.ca> <20070711080634.GA16426@enneenne.com> <20070711152238.GJ31193@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711152238.GJ31193@csclub.uwaterloo.ca>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 11:22:38AM -0400, Lennart Sorensen wrote:
> On Wed, Jul 11, 2007 at 10:06:34AM +0200, Rodolfo Giometti wrote:
> > My question is: how can I fit a 64 bits number of seconds into
> > timespec structure which, for 32 bits architetures, has a 32 bits bits
> > number of seconds?
> 
> I imagine you can't.  I have no idea if there are any intensions to
> change the definition of timespec on 32bit architectures, or if the
> thought is that they will all be dead before it becomes a problem. :)
> 
> I still think the API you define for PPS should support 64bit seconds,
> even if on some systems you can't take advantage of it.

So on 32 bits systems I simply drop the high part of the second
data... is that right?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
