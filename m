Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYBYKpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYBYKpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYBYKpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:45:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52130 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYBYKpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:45:11 -0500
To: greg@kroah.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-reply-to: <20080222231934.GA30703@kroah.com> (message from Greg KH on Fri,
	22 Feb 2008 15:19:34 -0800)
Subject: Re: [stable] [patch] fuse: fix permission checking
References: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu> <20080222231934.GA30703@kroah.com>
Message-Id: <E1JTapR-00079g-QF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 25 Feb 2008 11:45:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg!

> On Fri, Feb 15, 2008 at 11:23:47AM +0100, Miklos Szeredi wrote:
> > This is for 2.6.25 and 2.6.24.y, but NOT for 2.6.23.y.
> > 
> > Thanks,
> > Miklos
> > ----
> > 
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > I added a nasty local variable shadowing bug to fuse in 2.6.24, with
> > the result, that the 'default_permissions' mount option is basically
> > ignored.
> 
> When this goes into Linus's tree, can you let us know along with the git
> commit id?

It's now in Linus tree:

commit 1a823ac9ff09cbdf39201df37b7ede1f9395de83

Thanks,
Miklos
