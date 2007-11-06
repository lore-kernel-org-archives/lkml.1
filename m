Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbXKFJoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbXKFJoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXKFJoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:44:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56158 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbXKFJoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:44:10 -0500
Subject: Re: [linux-usb-devel] device struct bloat
From: Peter Zijlstra <peterz@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>
In-Reply-To: <200711051738.35080.david-b@pacbell.net>
References: <20071103124823.6059640e@shemminger-laptop>
	 <1194260234.27652.425.camel@twins> <20071105224929.GA30521@kroah.com>
	 <200711051738.35080.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 10:43:42 +0100
Message-Id: <1194342222.6544.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-05 at 17:38 -0800, David Brownell wrote:
> On Monday 05 November 2007, Greg KH wrote:
> > --- linux-2.6-2.orig/drivers/spi/spi.c
> > +++ linux-2.6-2/drivers/spi/spi.c
> 
> It'd be quicker to end up in the right hands if you had
> split this big and random patch according to subsystem...

Yeah, sorry, I just started converting mindlessly and stopped once it
compiled (which explains the missing FW bits, I don't have that in my
config). Then booted and fixed up what broke, well aside from the final
lockdep issue. As I couldn't get that fixed, I never looked twice,
didn't make it a proper patch-set, nor validated the rest of the patch.

Wasn't even planning on sending it out initially.

> There's already a patch in the MM queue that removes
> the SPI-private semaphore.  Except that it's missing
> the bug noted below.

Right, lack of a recent -mm made me work against mainline. I'm sure I
would've noticed otherwise :-)

