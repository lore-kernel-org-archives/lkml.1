Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZAMRfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZAMRfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZAMRfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:35:11 -0500
Received: from kroah.org ([198.145.64.141]:34133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753662AbZAMRfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:35:10 -0500
Date: Tue, 13 Jan 2009 08:56:30 -0800
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Add two VFS exports used by POHMELFS
Message-ID: <20090113165630.GA25450@kroah.com>
References: <20090113124346.GA26101@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113124346.GA26101@ioremap.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 03:43:46PM +0300, Evgeniy Polyakov wrote:
> Hi.
> 
> POHMELFS is a very high-performance parallel network filesystem with
> coherent local cache of data and metadata. It entered maintenance mode
> and is being prepared for the next submission cycle.
> I decided first to push it into the drivers/staging which was acked
> by Greg for the wider testing and review and move into the vanilla tree
> in the next merge window.
> 
> POHMELFS needs two exports from the core VFS: add_to_page_cache_lru and
> __lock_page_killable.
> 
> Please apply given patch to the current tree.
> 
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

Hm, usually we take exports at the same time the user goes into the
tree.

I don't mind adding these exports with the same patch series to add your
filesystem to the drivers/staging tree, if Andrew and the other vfs
developers agree it's a sane thing to be exporting.

thanks,

greg k-h
