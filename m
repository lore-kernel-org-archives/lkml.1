Return-Path: <linux-kernel-owner+w=401wt.eu-S2992599AbXEBAsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992599AbXEBAsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992588AbXEBAsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:48:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55058 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992584AbXEBAsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:48:03 -0400
Date: Tue, 1 May 2007 16:34:19 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] to something appropriate (was Re: 2.6.22 -mm merge
	plans)
Message-ID: <20070501233419.GA10462@kroah.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <46368062.6000100@garzik.org> <20070430170919.45e4b42b.akpm@linux-foundation.org> <463688AD.1050903@garzik.org> <20070501004036.GS2819@sequoia.sous-sol.org> <46368DA5.7070003@garzik.org> <20070501045806.GA3697@kroah.com> <46376748.6020408@redhat.com> <20070501174033.2046f289@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501174033.2046f289@the-village.bc.nu>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 05:40:33PM +0100, Alan Cox wrote:
> > > But distros can easily add the device id to their kernel if needed, it
> > > isn't something that the -stable tree shoud be accepting.  Otherwise, we
> > > will be swamped with those types of patches...
> > > 
> > 
> > Oh sure, leave the distros swamped with them instead. :)
> > 
> > And they all have to do it separately, meaning they don't stay in sync
> > and they duplicate each other's work...
> 
> Well they *don't* have to work that separately. They could set up some
> shared tree which would look suspiciously like what Greg is doing but
> with the ID updates.... ;)

And is this really a problem?  The whole goal of the -stable tree was to
accomidate the users who relied on kernel.org kernels, and wanted
bugfixes and security updates.  It was not for new features or new
hardware support.

If people feel we should revisit this goal, then that's fine, and I have
no objection to that.  But until then, I think the rules that we have
had in place for over the past 2 years should still remain in affect.

thanks,

greg k-h
