Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZAERkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZAERkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZAERkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:40:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZAERkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:40:31 -0500
Date: Mon, 5 Jan 2009 12:40:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Heikki Orsila <shdl@zakalwe.fi>, unsik Kim <donari75@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mflash linux support
Message-ID: <20090105174026.GA1855@infradead.org>
References: <57afda040901041718g1415e210hfd0991270dfdd72d@mail.gmail.com> <20090105023346.GE6115@zakalwe.fi> <20090105111321.7d210c01@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105111321.7d210c01@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:13:21AM +0000, Alan Cox wrote:
> On Mon, 5 Jan 2009 04:33:46 +0200
> Heikki Orsila <shdl@zakalwe.fi> wrote:
> 
> > A few style issues:
> 
> How about starting by worrying about the code not pointless style
> complaints ?
> 
> >> > +	switch (cmd) {
> > > +	case HDIO_GETGEO:
> > 
> > 	if (cmd == HDIO_GETGEO) {
> 
> Especially when you are making pointless complaints about things that are
> generally done the way the original code is - and for good reason. It
> makes it far cleaner to add new ioctl support.

Or either of you could check what blkdev_ioctl() does with HDIO_GETGEO
and why this code doesn't even need to exist at all.

