Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbXGJQfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbXGJQfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbXGJQfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:35:25 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:48506 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbXGJQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:35:24 -0400
Date: Tue, 10 Jul 2007 18:36:25 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070710163625.GH32503@enneenne.com>
References: <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <20070701171325.29d8b184.sfr@canb.auug.org.au> <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710160151.GB31195@csclub.uwaterloo.ca>
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

On Tue, Jul 10, 2007 at 12:01:51PM -0400, Lennart Sorensen wrote:
> On Sun, Jul 01, 2007 at 09:24:41PM +0200, Rodolfo Giometti wrote:
> >     struct pps_timedata_s {
> >        __32 sec;
> >        __32 nsec;
> >     }
> > 
> > Ok? I think 32 bits are enought for keeping seconds... :)
> 
> You want to purposely define an API that will break in 23 years (or is
> that 83 years since you made it unsigned potentially)?  Why not 64bit
> for seconds and 32bit for nsec.  That should cover it for long enough.
> When the unix time format was created 37 years ago, I could see thinking
> 32bit seemed reasonable, but why do it now.  We have ram enough for
> 64bits.

Sorry I wrote wrong. I meant __u32.

I can use __u64 for seconds but doing this there could be problems for
32 bits platforms? =:-o

Rodolfo (not a 64 bits guru :)

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
