Return-Path: <linux-kernel-owner+w=401wt.eu-S936202AbYEUSKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936202AbYEUSKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbYEUSKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:10:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57259 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbYEUSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:10:34 -0400
Date: Wed, 21 May 2008 11:09:57 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@sunset.davemloft.net>,
       systemtap@sources.redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] usb-storage: don't call utsname()
Message-ID: <20080521180957.GA17598@kroah.com>
References: <20080521123700.GA8770@infradead.org> <Pine.LNX.4.44L0.0805211349480.3409-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0805211349480.3409-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 01:51:17PM -0400, Alan Stern wrote:
> This patch (as1100) replaces the core-kernel function call to utsname()
> in usb-storage with the UTS_RELEASE macro.  It's used only for warning
> about extra unusual_devs entries.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Why?  With this change, if you change the version number, the file will
have to be rebuilt.  Without the change, the file will not need to be
rebuilt, right?

I thought that was why this change was made a while ago, to prevent
things from having to be rebuilt that didn't need to be.

thanks,

greg k-h
