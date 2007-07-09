Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbXGIKnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbXGIKnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXGIKnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:43:03 -0400
Received: from barikada.upol.cz ([158.194.242.200]:48023 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbXGIKnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:43:01 -0400
Date: Mon, 9 Jul 2007 12:56:11 +0200
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Makefiles for GNU make (Re: [PATCH] LinuxPPS (with new syscalls API) - new version)
Message-ID: <20070709105611.GS3895@flower.upol.cz>
References: <1182966588.1170.28.camel@pmac.infradead.org> <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <E1I7Shw-0003Em-4O@flower> <20070709091643.GF11451@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709091643.GF11451@enneenne.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 11:16:43AM +0200, Rodolfo Giometti wrote:
> On Sun, Jul 08, 2007 at 11:05:32AM +0200, Oleg Verych wrote:
> > * Rodolfo Giometti (Thu, 28 Jun 2007 18:14:50 +0200)
> > * Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
> > 
> > > +.PHONY : all depend dep
> > > +
> > > +all : .depend $(TARGETS)
> > > +
> > > +.depend depend dep :
> > > +	$(CC) $(CFLAGS) -M $(TARGETS:=.c) > .depend
> > []
> > > +# -- Clean section ------------------------------------------------------------
> > > +
> > > +.PHONY : clean
> > > +
> > > +clean :
> > > +	rm -f *.o *~ core .depend
> > 
> > Please see how currently .PHONY targets are used correctly, e.g. in
> > linux/Makefile.
> 
> I don't understand why you wish I use linux PHONY targets management

Sorry i was not clear. Problem is `GNU make'[0], not management.

[0] <http://article.gmane.org/gmane.comp.gnu.make.bugs/2481>

> in a documentation Makefile... I suppose you are talking about
> linux/Documentation/pps/Makefile which is just an example about people
> may compile some testing/debugging programs. :-o

So, after this example you may write correct Makefiles for `GNU make'.

> Ciao,
> 
> Rodolfo
> 
____
