Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbZD2Sdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbZD2Sdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbZD2Sdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:33:33 -0400
Received: from kroah.org ([198.145.64.141]:43581 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZD2Sdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:33:32 -0400
Date: Wed, 29 Apr 2009 11:30:12 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090429183012.GA28237@kroah.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 02:17:12PM -0400, Mike Frysinger wrote:
> >> find being able to run `usbmodules` pretty useful ... i wrote a script
> >> for fun:
> >> http://sources.gentoo.org/sys-apps/usbutils/files/usbmodules.sh
> >
> > Did that work on any 2.6 kernel?
> 
> it's the only version ive tested it with ... but it doesnt parse any
> kernel module directly, it reads the generated modules.usbmap file
> 
> > There's no reason we can't add "-k" support to lsusb like lspci has to
> > show the modules assigned to different devices.
> 
> the method i posted above only needs the module to be compiled, not loaded

As the map files are depreciated, I wouldn't continue to rely on it, it
will break in the future when the kernel stops generating those files.

thanks,

greg k-h
