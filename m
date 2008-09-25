Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYIYNAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYIYNAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYIYM7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:59:53 -0400
Received: from [198.145.64.141] ([198.145.64.141]:47686 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752286AbYIYM7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:59:53 -0400
Date: Thu, 25 Sep 2008 05:54:23 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Message-ID: <20080925125423.GB6750@kroah.com>
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net> <20080925024840.GA14575@kroah.com> <200809250829.22294.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200809250829.22294.pluto@agmk.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 08:29:22AM +0200, Paweł Sikora wrote:
> On Thursday 25 of September 2008 04:48:40 Greg KH wrote:
> > On Wed, Sep 24, 2008 at 05:07:59PM +0200, Paweł Sikora wrote:
> > > Hi All,
> > >
> > > with out-of-tree kernel modules we (users and linux distributions)
> > > have a problem - with every frequent kernel release we need
> > > to rebuild them all due to vermagic and possible abi changes.
> > > this leads to lot of useless work (bumping rpm specs releases,
> > > preparing rpm packages and so on).
> >
> > "we" are working hard to remove any and all barriers for modules to be
> > out-of-tree.  See the recent drivers/staging/ announcement, I can now
> > take pretty much any code that at least builds and works for someone,
> > and get it into the kernel tree where it can be properly cleaned up and
> > cared for over time before it moves to the "correct" location within the
> > kernel.
> >
> > What kernel modules do you currently use/rely on that are not in the
> > main kernel tree?  Do you have links to them?  I'd be glad to add them.
> 
> here's a quick list:
> 
> - http://www.lirc.org
> - http://sourceforge.net/projects/bluetooth-alsa
> - http://rt2x00.serialmonkey.com
> - http://www.unav-micro.com/Drivers.aspx -> AR81Family-linux-v1.0.1.0.tar.gz
>   (e.g. asus-p5q-pro m/b has such ethernet port, pciid=1969:1026)
> - http://aufs.sourceforge.net
> - http://linux-uvc.berlios.de
> - http://www.misdn.org
> - toshiba bluetooth module [http://0bits.com/toshbt/toshbt-1.0.tar.gz]
> - zaptel telephony driver [http://www.asterisk.org]
>   with firmware [http://downloads.digium.com/pub/telephony/firmware/releases]

I think Sitsofe has answered all of these links as to if they are
already merged, working on being merged, or refuse to be merged (like
zaptel.)

Are there any other out-of-tree modules that I need to be aware of to
help integrate?

If not, then there really isn't an issue here, right?  :)

thanks,

greg k-h
