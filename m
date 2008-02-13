Return-Path: <linux-kernel-owner+w=401wt.eu-S934373AbYBMSAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373AbYBMSAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934309AbYBMR7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:59:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44353 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934300AbYBMR7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:59:36 -0500
Date: Wed, 13 Feb 2008 09:55:52 -0800
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213175552.GA18984@kroah.com>
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <20080213002948.GA8899@kroah.com> <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org> <20080213061653.GA10784@kroah.com> <20080213103641.GD12785@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213103641.GD12785@mit.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 05:36:41AM -0500, Theodore Tso wrote:
> On Tue, Feb 12, 2008 at 10:16:53PM -0800, Greg KH wrote:
> > I was amazed at how slow stgit was when I tried it out.  I use
> > git-quiltimport a lot and I don't think it's any slower than just using
> > quilt on its own.  So I think that the speed issue should be the same.
> 
> I like using "guilt" because I can easily reapply the patchset using
> "guilt push -a", which is just slightly fewer characters to type than
> "git-quiltimport".  This also means that I don't need to switch back
> and forth between "git mode" and "quilt mode" when I'm editing the
> patches (either directly by editing the patch files, in which case
> afterwards I do a "guilt pop -a; guilt push -a", or by using "guilt
> pop", "guilt push", and "guilt refresh").

I had problems getting guilt to preserve metadata properly last time I
tried it, and it forced me to work with the same location and format
that the original developers used, which wasn't as flexable as quilt
could handle from what I recall.

But I'll try it again, it might have gotten better...

thanks,

greg k-h
