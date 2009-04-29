Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbZD2T2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbZD2T2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760166AbZD2T2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:28:38 -0400
Received: from kroah.org ([198.145.64.141]:42590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604AbZD2T2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:28:36 -0400
Date: Wed, 29 Apr 2009 12:23:09 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090429192309.GA15539@kroah.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 08:59:31PM +0200, Kay Sievers wrote:
> On Wed, Apr 29, 2009 at 20:17, Mike Frysinger <vapier.adi@gmail.com> wrote:
> 
> >>> looks like update-usbids.sh was forgotten from EXTRA_DIST in
> >>> Makefile.am so the released tarball doesnt have the script ;(
> 
> > np, i'll send patches for both
> 
> Ah missed that, sorry. Sounds good if you add it to the tarball, but
> please don't add it to "make install", as packages should not ship
> scripts which change the installed package content, unless it's a
> config file.

Distros ship uppdate-usbids.sh, like they do the same for the pci ids
file.  And you can consider the usb.ids file a "config file" :)

thanks,

greg k-h
