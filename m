Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZAMVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZAMVa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZAMVaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:30:16 -0500
Received: from netgear.net.ru ([195.178.208.66]:45483 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZAMVaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:30:15 -0500
Date: Wed, 14 Jan 2009 00:30:13 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Add two VFS exports used by POHMELFS
Message-ID: <20090113213013.GA27227@ioremap.net>
References: <20090113124346.GA26101@ioremap.net> <20090113165630.GA25450@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113165630.GA25450@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 08:56:30AM -0800, Greg KH (greg@kroah.com) wrote:
> > POHMELFS is a very high-performance parallel network filesystem with
> > coherent local cache of data and metadata. It entered maintenance mode
> > and is being prepared for the next submission cycle.
> > I decided first to push it into the drivers/staging which was acked
> > by Greg for the wider testing and review and move into the vanilla tree
> > in the next merge window.
> > 
> > POHMELFS needs two exports from the core VFS: add_to_page_cache_lru and
> > __lock_page_killable.
> > 
> > Please apply given patch to the current tree.
> > 
> > Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
> 
> Hm, usually we take exports at the same time the user goes into the
> tree.
> 
> I don't mind adding these exports with the same patch series to add your
> filesystem to the drivers/staging tree, if Andrew and the other vfs
> developers agree it's a sane thing to be exporting.

Ok, I can push them together (just right now :), Andrew, Linus, do you
agree to export those functions?

-- 
	Evgeniy Polyakov
