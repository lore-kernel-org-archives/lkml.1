Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbXKFVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbXKFVeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXKFVeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:34:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42107 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbXKFVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:34:01 -0500
Date: Tue, 6 Nov 2007 13:33:26 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nix.or.die@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded
Message-ID: <20071106213326.GA5085@kroah.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <4730CB42.4090106@googlemail.com> <20071106134052.71bf12d6.akpm@linux-foundation.org> <20071106210712.GA5993@kroah.com> <20071106141509.51e66ab3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106141509.51e66ab3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 02:15:09PM -0800, Andrew Morton wrote:
> > On Tue, 6 Nov 2007 13:07:12 -0800 Greg KH <greg@kroah.com> wrote:
> > > > [15745.009868]  =======================
> > > > [15745.009870] Code: d4 13 00 83 7c 24 04 00 75 0f 8b 43 14 83 c0 0c e8 fc fb ff ff 89 44 24 04 8b 43 14 8b 48 04 8d 53 08 89 50 04 89 43 08 89 4b 0c <89> 11 8b 43 14 83 c0 08 c6 00 01 8b 44 24 04 89 43 10 c7 04 24
> > > > [15745.009928] EIP: [<c01c50a2>] kobject_add+0xae/0x160 SS:ESP 0068:cfa37f40
> > > > 
> > > 
> > > Don't knowm sorry - we'll need to wait until someone can hit it more
> > > reliably :(
> > 
> > Ah, I have a fix for that, Kay found it.  Do you want an add-on to your
> > tree, or a whole new version of one of the patches?
> 
> Is OK, it looks like I need to resync everyone and undrop various
> trees.   A fix for perfmon would be nice.
> 
> It took five solid hours to get this lot vaguely compiling.  20-30
> fix patches needed, several trees dropped, 5-10 patches dropped.

Let me regenerate my tree, drop the block-device patch that you hate so
much, and then attack the perfmon code.  Should be done in a few hours.

Sound ok?

thanks,

greg k-h
