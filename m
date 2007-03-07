Return-Path: <linux-kernel-owner+w=401wt.eu-S965346AbXCGN17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346AbXCGN17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXCGN17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:27:59 -0500
Received: from mail.suse.de ([195.135.220.2]:54456 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965346AbXCGN16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:27:58 -0500
Date: Wed, 7 Mar 2007 05:26:21 -0800
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux v2.6.21-rc3
Message-ID: <20070307132621.GA8084@kroah.com>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <1173263132.9349.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173263132.9349.47.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:25:32AM +0100, Benjamin Herrenschmidt wrote:
> On Tue, 2007-03-06 at 20:59 -0800, Linus Torvalds wrote:
> 
> > Linus Torvalds (2):
> >       Revert "[PATCH] LOG2: Alter get_order() so that it can make use of ilog2() on a constant"
> >       Linux 2.6.21-rc3
> 
> Greg, I think we should revert that patch in 2.6.20.x stable serie too
> as get_order is broken there as well, causing random kernel memory
> corruption every now and then among others.

Now added to the -stable tree, thanks for pointing it out to me.

greg k-h
