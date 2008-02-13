Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYBMAZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYBMAZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYBMAZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:25:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47469 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYBMAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:25:41 -0500
Date: Tue, 12 Feb 2008 16:29:48 -0800
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, arjan@infradead.org, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213002948.GA8899@kroah.com>
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.155853.193190548.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 03:58:53PM -0800, David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Tue, 12 Feb 2008 11:36:24 -0500
> 
> > Rebasing is low impact only if you don't have git downstream people.
> > Otherwise, you're just treating it as a useful quilt clone, really.
> 
> Understood.
> 
> One of the key operations that I'm interested in is removing things
> from the history.  If I could do that using GIT without any side
> effects and in a way that really would remove it from the tree, I
> would do that in a heartbeat.
> 
> At 1500 changesets, a merge conflict shows up about once
> every day or two as 2.6.N nears it's release into final
> as bug fixes trickle in.
> 
> I find using GIT to fixup merge errors on a tree of that
> scale to be really painful.  And it only fixes up the final
> result in a merge changeset.

Perhaps you need to switch to using quilt.  This is the main reason why
I use it.

thanks,

greg k-h
