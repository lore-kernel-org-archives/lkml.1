Return-Path: <linux-kernel-owner+w=401wt.eu-S1764422AbXF1Iis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764422AbXF1Iis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 04:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762599AbXF1Iil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 04:38:41 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:40249 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762346AbXF1Iik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 04:38:40 -0400
Date: Thu, 28 Jun 2007 10:40:03 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070628084003.GQ13886@enneenne.com>
References: <20070627101449.GH13886@enneenne.com> <1182939510.6409.17.camel@pmac.infradead.org> <20070627125802.GI13886@enneenne.com> <1182960660.1170.12.camel@pmac.infradead.org> <20070627174537.GM13886@enneenne.com> <1182966588.1170.28.camel@pmac.infradead.org> <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183019474.1170.66.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 09:31:14AM +0100, David Woodhouse wrote:
> On Thu, 2007-06-28 at 10:15 +0200, Rodolfo Giometti wrote:
> > Do you think I should add these functions into my patch, even if I
> > cannot test it, or it's enought providing just the
> > compat_sys_time_pps_fetch() function? 
> 
> Probably best to put them in. That way, you make it easier for people to

Mmm... so I should provide new syscalls for _all_
architectures... gulp! :)

It could be acceptable, just for the first release, to provide the
support for x86 only?

In this manner we can have a first release of LinuxPPS in the main
line just for x86 and then me, or other people, may add support for
the several supported architectures.

> test. Ideally, you should also provide a simple program that other
> people can use to test it, preferably without needing hardware (or at
> least just a nullmodem cable and another test program at the other end
> of it).

I already have a basic testing program... I can add it into
Documentation/pps directory, can't I?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
