Return-Path: <linux-kernel-owner+w=401wt.eu-S941006AbXGaFQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941006AbXGaFQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbXGaFQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:16:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:44083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbXGaFQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:16:45 -0400
Date: Mon, 30 Jul 2007 22:16:23 -0700
From: Greg KH <gregkh@suse.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jeffm@suse.com,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 20/26] saa7134: fix thread shutdown handling
Message-ID: <20070731051623.GA10019@suse.de>
References: <20070731042108.546594256@blue.kroah.org> <20070731043330.GU3975@kroah.com> <1185858348.4407.69.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185858348.4407.69.camel@gaivota>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 02:05:48AM -0300, Mauro Carvalho Chehab wrote:
> Hi Greg,
> 
> Em Seg, 2007-07-30 ??s 21:33 -0700, Greg KH escreveu:
> > anexo Documento somente texto
> > (saa7134-fix-thread-shutdown-handling.patch)
> > -stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Jeff Mahoney <jeffm@suse.com>
> > 
> > This patch changes the test for the thread pid from >= 0 to > 0.
> > 
> > When the saa8134 driver initialization fails after a certain point, it goes
> 	   ^^^^^^^
> The patch is OK. however, the driver name is saa7134.

Heh, thanks, I've fixed the text of the patch.

greg k-h
