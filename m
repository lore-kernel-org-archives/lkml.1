Return-Path: <linux-kernel-owner+w=401wt.eu-S1765181AbYETRZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765181AbYETRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYETRZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:25:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37784 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612AbYETRZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:25:47 -0400
Date: Tue, 20 May 2008 10:23:30 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Implment a tty port structure and supporting
	logic
Message-ID: <20080520172330.GC11666@kroah.com>
References: <20080519144557.19326.74313.stgit@core> <20080519165049.GA19896@kroah.com> <20080520015241.bd66fff0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520015241.bd66fff0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 01:52:41AM -0700, Andrew Morton wrote:
> On Mon, 19 May 2008 09:50:49 -0700 Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, May 19, 2008 at 03:50:07PM +0100, Alan Cox wrote:
> > > Right now each tty has its own port level structure which means we can share
> > > no code between ports. Introduce a structure and some initial minor helper
> > > routines so that we can move towards commonality. In doing this the USB serial
> > > code gets a bit of shake up as it kept using port->tty unsafely. Fixing that
> > > means changing the API of all the USB serial drivers. On the bright side the
> > > API now looks far more like the tty layer API which will become useful later
> > > on.
> > 
> > Very nice.
> > 
> > If you don't mind, I'll be glad to take this through my tree as you are
> > touching the usb-serial drivers so much.  Andrew, any objection to this?
> 
> A lot depends on what else Alan is brewing up.  I only have a single
> tty-related patch at present (remove-is_tty.patch) and a handful of
> possibly-related char driver patches
> (proper-extern-for-mwave_s_mdd.patch, if-0-hpet_unregister.patch and
> riscom8-remove-redundant-null-pointer-test.patch).
> 
> But if a great mountain of tty- and/or char-related patches is
> forthcoming, that mountain will probably have a depencency upon your
> tree.  And that's OK too, as long as you don't go and bugger up your
> tree and get it dropped from linux-next!  Because if that happens I'll
> need to temporarily drop all the dependent patches and remember to
> restore them, which is always a bit sad.

That's up to Alan, I don't know what he has brewing for 2.6.27.

Alan?

thanks,

greg k-h
