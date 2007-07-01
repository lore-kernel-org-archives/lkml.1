Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbXGATXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbXGATXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbXGATXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 15:23:32 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49382 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbXGATXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 15:23:32 -0400
Date: Sun, 1 Jul 2007 21:24:41 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070701192441.GW13886@enneenne.com>
References: <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <20070701171325.29d8b184.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701171325.29d8b184.sfr@canb.auug.org.au>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 05:13:25PM +1000, Stephen Rothwell wrote:
> On Sat, 30 Jun 2007 19:13:40 +0200 Rodolfo Giometti <giometti@enneenne.com> wrote:
> >
> > Maybe I can define a special struct for exchanging time data as:
> > 
> >    struct pps_timedata_s {
> >       long sec;
> >       long nsec;
> >    }
> > 
> > and managing time data conversions at userland...
> > 
> > What do you think about that? :)
> 
> "long" is one of the datatypes that changes size between 32 bit and 64
> bit, so not such a good choice. You could use __u32 or __64 (or
> whatever), that makes it very clear that these are fixed size data types.

    struct pps_timedata_s {
       __32 sec;
       __32 nsec;
    }

Ok? I think 32 bits are enought for keeping seconds... :)

If you have no more advices I think I can start changing this part in
order to avoid using struct timespec.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
