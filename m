Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZDPBal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZDPBal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZDPBa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:30:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:55643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZDPBa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:30:29 -0400
Date: Wed, 15 Apr 2009 18:32:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415183213.7962d929@infradead.org>
In-Reply-To: <49E657BC.6000707@rtr.ca>
References: <49E4FAC6.1030400@garzik.org>
	<20090415014930.GA29413@kroah.com>
	<49E5480F.10501@garzik.org>
	<20090415050947.GB3462@kroah.com>
	<49E5EE41.3090505@rtr.ca>
	<20090415073001.503b0361@infradead.org>
	<49E5FF48.3030809@rtr.ca>
	<20090415125813.34c9a151@infradead.org>
	<49E657BC.6000707@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 17:55:08 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Arjan van de Ven wrote:
> > On Wed, 15 Apr 2009 11:37:44 -0400
> > Mark Lord <lkml@rtr.ca> wrote:
> > 
> >> Arjan van de Ven wrote:
> >>> On Wed, 15 Apr 2009 10:25:05 -0400
> >>> Mark Lord <lkml@rtr.ca> wrote:
> ..
> >>>> Not forever, just a few seconds to compensate for the regression.
> >>> seconds!!!!!
> >>> The whole kernel boots in half a second!
> >> ..
> >>
> >> Oh, absolutely I agree.
> >>
> >> That's why I'm not suggesting a DELAY
> >> but rather a TIMEOUT (where it keeps trying up until the timeout).
> > 
> > This exists today. It's just not something Jeff chose to use ;)
> > (because he didn't need to)
> > 
> >> For desktop, it should really just wait forever,
> >> but I can understand situations (server room)
> >> where that would be a Really Bad Idea.
> > 
> > it's called rootwait and such :)
> ..
> 
> No, that's not the same thing.
> rootwait has no timeout -- it waits *forever*,
> which will break auto-recovery on servers.

btw while I don't disagree that something like this is nice...

.... who would boot their server from a USB stick for production use?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
