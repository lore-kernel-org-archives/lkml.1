Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZFCVX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZFCVX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZFCVXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:23:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:39060 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZFCVXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:23:19 -0400
Date: Wed, 3 Jun 2009 14:13:13 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Baruch Siach <baruch@tkos.co.il>, spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH] spi: driver for the Synopsys
	DesignWare SPI controller
Message-ID: <20090603211312.GA5123@suse.de>
References: <1243338914-7811-1-git-send-email-baruch@tkos.co.il> <63386a3d0905271416u4b2cee48k40c12e91e1796f83@mail.gmail.com> <20090531080434.GA16463@jasper.tkos.co.il> <63386a3d0905311227v5bb5c278r306e8ae429e77691@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63386a3d0905311227v5bb5c278r306e8ae429e77691@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 09:27:56PM +0200, Linus Walleij wrote:
> 2009/5/31 Baruch Siach <baruch@tkos.co.il>:
> 
> >> > +       r = platform_get_resource(dev, IORESOURCE_MEM, 0);
> >> > +       if (r == NULL) {
> >> > +               ret = -ENODEV;
> >>
> >> -ENOENT
> >
> > A quick search in the drivers tree showed no -ENOENT in this situation. Of the
> > 10 first results of grep -ENODEV is the most popular as follows:
> [The other: 3x -EINVAL one -ENXIO]
> 
> Wowsers! And I felt -ENOENT was so intuitive, well if I'm going against
> common practice, no good. So let's ask the maintainer of the platform bus
> what shall be returned in this situation:
> 
> Greg (or some other wise person from linux-kernel) what would you return if
> platform_get_resource() returns NULL for an expected resource?

I really have no idea, sorry.

Pick something :)

thanks,

greg k-h
