Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbXBYFrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbXBYFrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933663AbXBYFrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:47:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37455 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662AbXBYFrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:47:00 -0500
Date: Sun, 25 Feb 2007 05:46:59 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070225054658.GC7941@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain> <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron> <20070220145503.GC3170@thunk.org> <1171984908.4039.42.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171984908.4039.42.camel@sauron>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 05:21:48PM +0200, Artem Bityutskiy wrote:
> > In that case it's not an *implementation* version number, but rather
> > an on-disk *format* version number. 
> 
> True, will refine the comment.
> 
> >  There's a difference.  It's also
> > often not used much, since another way of dealing with the problem is
> > to mark major each on-disk version with a different magic number.
> 
> The advantage of version is that UBI can distinguish between garbage and
> incompatible image. If I meet wrong magic - what is it - rubbish,
> corrupted header? Should I run recovery procedure? Having version is
> just cleaner.

Agreed.  

> > Why isn't this being done via #define?  It's not like this is any kind
> > of an enumerated type, especially since it's being installed into a
> > 32bit type, and not even an enum type.
> 
> Will be fixed, thanks.

We currently try to use enums for most constants, then again this really
doesn't matter all that much.
