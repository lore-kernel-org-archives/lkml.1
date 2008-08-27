Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYH0AJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYH0AJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYH0AJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:09:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:52169 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYH0AJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:09:48 -0400
Date: Tue, 26 Aug 2008 17:06:40 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, hjk@linutronix.de
Subject: Re: [PATCH, RFC] uio BKL removal
Message-ID: <20080827000640.GC29570@kroah.com>
References: <20080826171532.2414c7a2@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826171532.2414c7a2@bike.lwn.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 05:15:32PM -0600, Jonathan Corbet wrote:
> I had a moment to dedicate to the BKL removal cause, so I went for the
> UIO driver, which seemed simple.  The main thing I found was that there
> was locking around some idr accesses, but not all, so I filled that
> in.  With that in place, removing the BKL from uio_open() seems safe,
> especially since none of the in-tree UIO drivers have open() or
> release() methods.  
> 
> (Incidentally, I don't see how uio_pdrv.c could ever work - who initializes
> uioinfo?)
> 
> If there's no complaints, I'll feed this into linux-next via the
> bkl-removal tree.

Looks good to me, feel free to add an:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to it.

greg k-h
