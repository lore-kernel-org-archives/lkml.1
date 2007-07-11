Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbXGKIFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbXGKIFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXGKIFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:05:33 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:59404 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbXGKIFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:05:30 -0400
Date: Wed, 11 Jul 2007 10:06:34 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070711080634.GA16426@enneenne.com>
References: <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <20070701171325.29d8b184.sfr@canb.auug.org.au> <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca> <20070710163625.GH32503@enneenne.com> <20070710220310.GI31193@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710220310.GI31193@csclub.uwaterloo.ca>
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

On Tue, Jul 10, 2007 at 06:03:10PM -0400, Lennart Sorensen wrote:
> 
> 32bit platforms can still work with 64bit values, they may just not be
> quite as efficient about it.
> 
> After all we support files with more than 2^32 bytes in them, so the
> file access structures must have more than 32bit values in them.

My question is: how can I fit a 64 bits number of seconds into
timespec structure which, for 32 bits architetures, has a 32 bits bits
number of seconds?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
