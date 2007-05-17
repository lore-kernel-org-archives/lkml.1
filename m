Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbXEQSWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbXEQSWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXEQSWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:22:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59087 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbXEQSWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:22:18 -0400
Date: Thu, 17 May 2007 20:23:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@lst.de>
Cc: David Woodhouse <dwmw2@infradead.org>, dedekind@infradead.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517182314.GA5584@uranus.ravnborg.org>
References: <20070517143200.GA30850@lst.de> <1179417055.2859.506.camel@shinybook.infradead.org> <20070517181223.GA17765@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517181223.GA17765@lst.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 08:12:23PM +0200, Christoph Hellwig wrote:
> On Thu, May 17, 2007 at 11:50:54PM +0800, David Woodhouse wrote:
> > On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> > > Kill ubis homegrown endianess handling crap and replace it with
> > > the normal kernel endianess handling. 
> > 
> > NAK. The 'normal' kernel stuff doesn't work in GCC; only in sparse.
> > 
> > If you want to go removing the ones which _do_ work in GCC, then fix the
> > 'normal' one first. _Then_ go about converting others over to it.
> 
> Nope.  gcc checking is crap and we need to run sparse anyway.  It's what
> everyone in the kernel use so it's perfect for some random code almost
> no one uses aswell.

Care to explain what is wrong with the gcc checks as used by UBI?
Would be nice to know before someone start to migrate current
stuff so gcc can check for correct endian.

	Sam
