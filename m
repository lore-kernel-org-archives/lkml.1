Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbXF1ON6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbXF1ON6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbXF1ONt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:13:49 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:43773 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbXF1ONt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:13:49 -0400
Date: Thu, 28 Jun 2007 16:15:11 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070628141511.GB13886@enneenne.com>
References: <20070627125802.GI13886@enneenne.com> <1182960660.1170.12.camel@pmac.infradead.org> <20070627174537.GM13886@enneenne.com> <1182966588.1170.28.camel@pmac.infradead.org> <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1183031060.1170.145.camel@pmac.infradead.org>
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

On Thu, Jun 28, 2007 at 12:44:20PM +0100, David Woodhouse wrote:
> 
> It's nice if you can do so, but I wouldn't suggest that you _have_ to.
> I have to admit that I rarely bother actually wiring new system calls up
> on anything but PowerPC to start with.
> 
> The important thing is that you've _considered_ the other architectures,
> and the 32/64 compatibility implications. As long as the API of your new
> system call is sensible and takes that kind of thing into account, it
> should be fine.

Ok. :)

> Had you considered changing the API so that you don't need the
> compatibility wrapper at all? Could you take an integer number of µS or
> ms instead of a struct timespec?

Not before now, but I followed the API specified into RFC 2783 who
specifies struct timespec...

Thanks for your suggestions! I'll send a new patch ASAP!

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
