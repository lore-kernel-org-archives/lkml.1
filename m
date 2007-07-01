Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXGAT0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXGAT0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 15:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbXGAT0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 15:26:38 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49406 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbXGAT0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 15:26:38 -0400
Date: Sun, 1 Jul 2007 21:27:55 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070701192755.GX13886@enneenne.com>
References: <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <1183291392.2828.17.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183291392.2828.17.camel@shinybook.infradead.org>
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

On Sun, Jul 01, 2007 at 01:03:11PM +0100, David Woodhouse wrote:
> 
> Seems reasonable enough in principle -- but whatever you do, don't use
> "long" for it. That would definitely need different behaviour for 32-bit
> vs. 64-bit. Use explicitly sized types such as uint32_t or uint64_t.

Which is the difference in using __u32 or uint32_t? Maybe is better
defining the new struct as follow?

    struct pps_timedata_s {
       uint32_t sec;
       uint32_t nsec;
    }

or as:

    struct pps_timedata_s {
	__u32 sec;
	__u32 nsec;
    }

?

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
