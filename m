Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab0AOHlt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 02:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832Ab0AOHls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 02:41:48 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:55369 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab0AOHls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 02:41:48 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Date: Thu, 14 Jan 2010 21:39:26 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc4; KDE/4.2.4; x86_64; ; )
Cc: Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org
References: <201001122242.22774.mitov@issp.bas.bg> <20100114031345.GA22542@aao.gov.au> <20100114034055.GA27311@kroah.com>
In-Reply-To: <20100114034055.GA27311@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001142139.26837.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
> > 
> > No. They are both standalone drivers. If we want V4L2 compatibility
> > we would have to modify (either) driver significantly.

Both are character drivers. My one uses open, read, mmap, ioctl, close.
Mainly tested on read. mmap works, but not yet extensively tested.
ioctl is used to start/stop acquisition, get info about buffer length,
and some error statistics collected during acquisitions.

see:

http://lfb.issp.bas.bg/~mitov/linux/dt3155pci/00README

for more detailed description.
> 
> Well, that will be the requirement to get it merged into the main
> portion of the kernel tree.  No special interfaces are allowed, sorry.

I do not quite understand V4L2 lib in particular how can I get a
contiguous buffer in physical memory which do not cross 4MB
boundary (hardware requirement).

Thanks,

Marin Mitov
