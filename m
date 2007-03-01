Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXCAAL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXCAAL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXCAAL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:11:58 -0500
Received: from ns1.suse.de ([195.135.220.2]:35294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbXCAAL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:11:57 -0500
Date: Thu, 1 Mar 2007 01:11:42 +0100
From: Bernhard Walle <bernhard.walle@gmx.de>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       gernot.hillier@siemens.com
Subject: Re: MOST(Media Oriented Systems Transport) Interface?
Message-ID: <20070301001142.GA6806@strauss.suse.de>
Mail-Followup-To: Jan Kiszka <jan.kiszka@web.de>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	linux-kernel@vger.kernel.org, gernot.hillier@siemens.com
References: <200702231826.30395.rgetz@blackfin.uclinux.org> <45E60EBD.2090806@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E60EBD.2090806@web.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Jan Kiszka <jan.kiszka@web.de> [2007-03-01 00:22]:
> Robin Getz wrote:
> > Does anyone have a pointer for a MOST (Media Oriented Systems Transport) driver?
> > 
> > http://en.wikipedia.org/wiki/Media_Oriented_Systems_Transport
> > 
> > I have seen announcements of Linux systems that support MOST:
> > 
> > http://linuxdevices.com/news/NS2586090082.html
> > 
> > But I have not seen the driver architecture, or the protocol that people are running on them...
> > 
> > Any pointers? 
> 
> The were some rumours earlier, but now I actually stumbled over the
> release - and recalled this thread.

Quite interesting that you found it. It was released yesterday, and I
wanted to write an announcement in a few days, at least at the Xenomai
lists. Anyway ...

> This might be what you are looking for:
> 
> http://most4linux.sourceforge.net/

Yes, that's a MOST driver for a OS 8604 PCI interface that I wrote as
Diploma Thesis at Siemens. It was relased as OpenSource just now.

It only supports synchronous data transfer. The Most NetServices are
in userspace. There's a OpenSource demonstration available, but no
full NetServices implementation. You can buy a license from SMC or use
the specification to re-write an OSS implementation. However, that's
all userspace, so no GPL problem here. :)

I must say that it was more a demonstration how a Linux driver could
be ported to real-time Linux extension than a real productive working
MOST driver for Linux.

Well, but of course, it works. At least it did in my environement
(i386/single-CPU).

You can find more information on the homepage ...



Regards,
Bernhard

PS: SUSE has nothing to do with that driver, I only write with my SUSE
address because I don't want to re-subscribe because of one mail.
