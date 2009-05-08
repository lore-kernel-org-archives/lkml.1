Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZEHEGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZEHEGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZEHEFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:05:55 -0400
Received: from kroah.org ([198.145.64.141]:37894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZEHEFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:05:54 -0400
Date: Thu, 7 May 2009 21:01:01 -0700
From: Greg KH <greg@kroah.com>
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.82 release
Message-ID: <20090508040101.GC31689@kroah.com>
References: <20090506222439.GB22327@kroah.com> <a276da400905070451j550d9a9ajcdd3ab30b03278aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a276da400905070451j550d9a9ajcdd3ab30b03278aa@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 07:51:23PM +0800, Xiaofan Chen wrote:
> On Thu, May 7, 2009 at 6:24 AM, Greg KH <greg@kroah.com> wrote:
> > Here's the 0.82 release of usbutils.
> >
> > Many bugs with autoconf were resolved to hopefully make it easier for
> > distros to find where the usb.ids file is dynamically.  Wireless USB
> > device support was added, as well as other bugfixes.  The full shortlog
> > is below.
> >
> > The tarballs can be downloaded from sf.net at:
> >        https://sourceforge.net/project/showfiles.php?group_id=3581
> >
> 
> Not sure if this is a real problem or not. There is a compiler warning
> for gcc 4.4.0.
> 
> gcc -DHAVE_CONFIG_H -I.   -DDATADIR=\"/usr/share\"   -g -O2 -MT
> lsusb-names.o -MD -MP -MF .deps/lsusb-names.Tpo -c -o lsusb-names.o
> `test -f 'names.c' || echo './'`names.c
> names.c: In function ‘names_init’:
> names.c:803: warning: assignment makes pointer from integer without a cast

Care to provide a patch for this?

thanks,

greg k-h
