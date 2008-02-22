Return-Path: <linux-kernel-owner+w=401wt.eu-S934874AbYBVX2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874AbYBVX2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932708AbYBVX1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:27:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45525 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760157AbYBVX1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:27:06 -0500
Date: Fri, 22 Feb 2008 15:19:34 -0800
From: Greg KH <greg@kroah.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch] fuse: fix permission checking
Message-ID: <20080222231934.GA30703@kroah.com>
References: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 11:23:47AM +0100, Miklos Szeredi wrote:
> This is for 2.6.25 and 2.6.24.y, but NOT for 2.6.23.y.
> 
> Thanks,
> Miklos
> ----
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> I added a nasty local variable shadowing bug to fuse in 2.6.24, with
> the result, that the 'default_permissions' mount option is basically
> ignored.

When this goes into Linus's tree, can you let us know along with the git
commit id?

thanks,

greg k-h
