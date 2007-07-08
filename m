Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbXGHIwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbXGHIwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 04:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXGHIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 04:52:24 -0400
Received: from barikada.upol.cz ([158.194.242.200]:37080 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbXGHIwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 04:52:23 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
In-Reply-To: <20070628161450.GD13886@enneenne.com>
References: <20070627125802.GI13886@enneenne.com> <1182960660.1170.12.camel@pmac.infradead.org> <20070627174537.GM13886@enneenne.com> <1182966588.1170.28.camel@pmac.infradead.org> <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com>
Date: Sun, 8 Jul 2007 11:05:32 +0200
Message-Id: <E1I7Shw-0003Em-4O@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rodolfo Giometti (Thu, 28 Jun 2007 18:14:50 +0200)
* Organization: GNU/Linux Device Drivers, Embedded Systems and Courses

> +.PHONY : all depend dep
> +
> +all : .depend $(TARGETS)
> +
> +.depend depend dep :
> +	$(CC) $(CFLAGS) -M $(TARGETS:=.c) > .depend
[]
> +# -- Clean section ------------------------------------------------------------
> +
> +.PHONY : clean
> +
> +clean :
> +	rm -f *.o *~ core .depend

Please see how currently .PHONY targets are used correctly, e.g. in
linux/Makefile.
____
