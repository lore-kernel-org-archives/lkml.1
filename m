Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbXGIJPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbXGIJPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXGIJPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:15:33 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:53449 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXGIJPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:15:32 -0400
Date: Mon, 9 Jul 2007 11:16:43 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070709091643.GF11451@enneenne.com>
References: <20070627174537.GM13886@enneenne.com> <1182966588.1170.28.camel@pmac.infradead.org> <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <E1I7Shw-0003Em-4O@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I7Shw-0003Em-4O@flower>
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

On Sun, Jul 08, 2007 at 11:05:32AM +0200, Oleg Verych wrote:
> * Rodolfo Giometti (Thu, 28 Jun 2007 18:14:50 +0200)
> * Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
> 
> > +.PHONY : all depend dep
> > +
> > +all : .depend $(TARGETS)
> > +
> > +.depend depend dep :
> > +	$(CC) $(CFLAGS) -M $(TARGETS:=.c) > .depend
> []
> > +# -- Clean section ------------------------------------------------------------
> > +
> > +.PHONY : clean
> > +
> > +clean :
> > +	rm -f *.o *~ core .depend
> 
> Please see how currently .PHONY targets are used correctly, e.g. in
> linux/Makefile.

I don't understand why you wish I use linux PHONY targets management
in a documentation Makefile... I suppose you are talking about
linux/Documentation/pps/Makefile which is just an example about people
may compile some testing/debugging programs. :-o

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
