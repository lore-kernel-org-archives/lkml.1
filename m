Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZIPMpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZIPMpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758406AbZIPMpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:45:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbZIPMpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:45:32 -0400
Date: Wed, 16 Sep 2009 08:45:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches for 2.6.31-git
Message-ID: <20090916124533.GA11222@infradead.org>
References: <20090915181247.GA32167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915181247.GA32167@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 11:12:47AM -0700, Greg KH wrote:
> Here is the driver core patchset for the 2.6.31 merge window
> 
> It consists of a variety of different things:
> 	- devtmpfs.  This has been discussed a lot, is tiny,
> 	  self-contained, and has been acked by all of the major distros
> 	  as something they will use, and it has been used in the SuSE
> 	  kernels for quite some time now.

Grr, as Greg didn't Cc the actual patches to Linus here's the objection
again:

 - it mounts a filesystem into the init (aka global) namespace on mount
   for no good reason
 - it then manipulates it using the high-level VFS functions which it
   could just do on any filesystem if it really wanted

These lots of dicussions were basically people telling Greg that he
should come up wit ha real problem instead of just pushing it for it's
own sake.  Arjan And Eric have very well refuted the spped claim.

NACK from me from the VFS point of view - this is devfs 2.0, just worse
than the last version of devfs 1.  I would really really like to head
what the udev folks actually want instead of pushing in this crap.

