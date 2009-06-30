Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZF3FOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZF3FOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 01:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZF3FOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 01:14:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:49377 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZF3FOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 01:14:11 -0400
Date: Mon, 29 Jun 2009 22:15:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Message-ID: <20090629221509.1d307184@infradead.org>
In-Reply-To: <20090629162853.GB3461@localdomain.by>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
	<6JJ2m5kyucK.A.D2D.VJASKB@chimera>
	<20090629154119.2c61f234@lxorguk.ukuu.org.uk>
	<20090629162853.GB3461@localdomain.by>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 19:28:53 +0300
Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:

> On (06/29/09 15:41), Alan Cox wrote:
> > > This message has been generated automatically as a part of a
> > > report of recent regressions.
> > > 
> > > The following bug entry is on the current list of known
> > > regressions from 2.6.30.  Please verify if it still should be
> > > listed and let me know (either way).
> > 
> > Yes although getting people seeing to test with might_sleep()
> > checks in the tty layer demonstrate the tty layer isn't calling
> > into ppp with irqs disabled when it shouldn't so I'm at a loss as
> > to whether this is a network bug, a scheduler bug or something else.
> > 
> > The schedule error in __tasklet_schedule() is itself rather
> > peicular.
> > 
> 
> Hello Alan, Rafael,
> 
> BUG is still here...


can you enable CONFIG_DEBUG_INFO, and then run this through
scripts/markup_oops.pl ? With a bit of luck it'll point to the exact
code that's going wrong...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
