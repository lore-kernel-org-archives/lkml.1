Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbXIISqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbXIISqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbXIISqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:46:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58142 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbXIISqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:46:13 -0400
Date: Sun, 9 Sep 2007 19:44:28 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, linuxsh-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Maple bus support for the Sega Dreamcast
Message-ID: <20070909194428.3ca83861@laptopd505.fenrus.org>
In-Reply-To: <8b67d60709091136s4629d8e7tb1ec0e583a2ac52f@mail.gmail.com>
References: <8b67d60709090946y31508ffhf752414872368d8c@mail.gmail.com>
	<20070909192807.3bc2410d@laptopd505.fenrus.org>
	<8b67d60709091136s4629d8e7tb1ec0e583a2ac52f@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 19:36:52 +0100
"Adrian McMenamin" <lkmladrian@gmail.com> wrote:

> Fair enough.
> 
> > > +
> > > +void maple_add_packet(struct mapleq *mq)
> > > +{
> > > +     list_add((struct list_head *) mq, &maple_waitq);
> > > +}
> >
> > for example this list.. what makes sure that no 2 pieces of code
> > muck with it at the same time?
> >
> >
> 
> Because everything is handled by one kernel thread on a uniprocessor
> machine.

hmmm.... still. Once you look at it from any other place... preempt etc
etc... it's sort of playing russian roulette with an empty gun, but
without checking that the gun is actually empty... at some point
someone may accidentally leave a bullet in ;)
