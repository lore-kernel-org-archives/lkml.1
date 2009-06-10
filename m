Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbZFJXAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbZFJXAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZFJXAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:00:07 -0400
Received: from kroah.org ([198.145.64.141]:35326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025AbZFJXAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:00:06 -0400
Date: Wed, 10 Jun 2009 15:49:34 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, tom.leiming@gmail.com,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] init/do_mounts.c: replace polling for root device
	with devtmpfs_wait_for_dev
Message-ID: <20090610224934.GA29847@kroah.com>
References: <1244644097-305-1-git-send-email-tom.leiming@gmail.com> <20090610152811.GA21888@infradead.org> <20090610163712.3b5297d7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610163712.3b5297d7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 04:37:12PM +0100, Alan Cox wrote:
> > What tree did you find with devtmpfs in it?  It was pretty clearly
> > rejected when it came up.
> 
> For some reason its still in -next

Yes, it's still in -next, sorry, I just realized this, as it's in my
driver-core tree.  We will be resubmitting it for .32 later on.
Discussion will happen after the .31 merge window is over.

thanks,

greg k-h
