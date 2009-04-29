Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbZD2TaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbZD2TaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZD2TaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:30:05 -0400
Received: from kroah.org ([198.145.64.141]:42596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbZD2TaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:30:04 -0400
Date: Wed, 29 Apr 2009 12:26:50 -0700
From: Greg KH <greg@kroah.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090429192650.GB15604@kroah.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> <20090429191841.GA1598@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429191841.GA1598@khazad-dum.debian.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 04:18:41PM -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 29 Apr 2009, Kay Sievers wrote:
> > >>> looks like update-usbids.sh was forgotten from EXTRA_DIST in
> > >>> Makefile.am so the released tarball doesnt have the script ;(
> > 
> > > np, i'll send patches for both
> > 
> > Ah missed that, sorry. Sounds good if you add it to the tarball, but
> > please don't add it to "make install", as packages should not ship
> > scripts which change the installed package content, unless it's a
> > config file.
> 
> Debian places it in /var/lib/usbids/ for a good reason.  So does Ubuntu.
> Both have working "update-usbids" scripts (might be the one from upstream,
> or something different).  They also have the original file in /usr/share, I
> don't know if usbutils was changed to check /var first then /usr, or what.

Yeah, I was looking into doing some kind of "where to look first" type
thing like lspci does.

Any suggestions?  Specific directory locations and hierarchy that
distros are already using?

thanks,

greg k-h
