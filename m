Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbZJBRCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbZJBRCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZJBRCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:02:03 -0400
Received: from kroah.org ([198.145.64.141]:42847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbZJBRCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:02:01 -0400
Date: Fri, 2 Oct 2009 09:59:37 -0700
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091002165937.GA4007@kroah.com>
References: <20090924154023.GA27480@localhost>
 <200909242103.48562.oliver@neukum.org>
 <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
 <20090924211459.GB27963@localhost>
 <4ABD020B.4040901@gandalf.sssup.it>
 <20090929145514.GF2152@localhost>
 <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
 <m163ayzevu.fsf@fess.ebiederm.org>
 <20091002084755.GA7382@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002084755.GA7382@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 10:47:55AM +0200, Johan Hovold wrote:
> On Thu, Oct 01, 2009 at 07:52:21PM -0700, Eric W. Biederman wrote:
> > Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > 
> > >> As it stands today ftdi_sio does indeed call tty_flip_buffer_push from
> > >> interrupt context with low_latency set and that is obviously incorrect,
> > >> right?
> > >
> > > It seems to do it from a work queue - or did I miss a case ?
> > 
> > ftdi_sio crash quite regularly for me with 2.6.31.
> > 
> > With a bunch of nasties like:
> > BUG: scheduling while atomic: swapper/0/0x00010000
> > bad: scheduling from the idle thread!
> 
> It's the same problem.
> 
> Greg, can't we apply the patch for stable at least? Then we can massage
> ftdi_sio into actually using the work queue for doing _all_ processing
> in the meantime if deemed necessary.

Patches need to be in Linus's tree first, before they can get into the
-stable releases.

I'm still digging through my patch queue, sorry, been swamped with the
-stable stuff, due to the merge window and 4 conferences over the past 2
weeks...

thanks,

greg k-h
