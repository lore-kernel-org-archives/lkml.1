Return-Path: <linux-kernel-owner+w=401wt.eu-S1765284AbXKNV45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765284AbXKNV45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758091AbXKNV4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:56:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46452 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764954AbXKNV4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:56:20 -0500
Date: Wed, 14 Nov 2007 13:42:34 -0800
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [stable] [PATCH 5/6] drivers/video/ps3fb: fix memset size error
Message-ID: <20071114214234.GB9901@kroah.com>
References: <472E7FBC.7020906@cn.fujitsu.com> <Pine.LNX.4.62.0711050930170.1532@pademelon.sonytel.be> <Pine.LNX.4.62.0711051359140.28623@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0711051359140.28623@pademelon.sonytel.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 02:00:45PM +0100, Geert Uytterhoeven wrote:
> On Mon, 5 Nov 2007, Geert Uytterhoeven wrote:
> > On Mon, 5 Nov 2007, Li Zefan wrote:
> > > The size passing to memset is wrong.
> > > 
> > > Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
> > 
> > Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> As this leaks 24 bytes of uninitialized stack to user space, probably this
> should be applied to -stable, too?

I'll be glad to apply it, once it goes to Linus's tree.  Can you all
resend this to stable@kernel.org when it goes into his tree?

thanks,

greg k-h
