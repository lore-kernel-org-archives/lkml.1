Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbXEGUCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbXEGUCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934520AbXEGUCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:02:15 -0400
Received: from www.osadl.org ([213.239.205.134]:41554 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934030AbXEGUCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:02:13 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Mon, 7 May 2007 22:01:46 +0200
User-Agent: KMail/1.9.5
Cc: akpm <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <200705041137.09403.hjk@linutronix.de> <20070507104629.79185cb5.randy.dunlap@oracle.com>
In-Reply-To: <20070507104629.79185cb5.randy.dunlap@oracle.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705072201.46513.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 07 Mai 2007 19:46 schrieb Randy Dunlap:
> On Fri, 4 May 2007 11:37:09 +0200 Hans-Jürgen Koch wrote:
> 
> > Am Donnerstag 03 Mai 2007 08:39 schrieb Hans-Jürgen Koch:
> > > > 
> > > > Hm, I have about 3 different patches here now, all dependant on each
> > > > other, yet I can't tell which goes first :(
> > > > 
> > > > Can someone just send me 1, or 3 with the correct order in which to
> > > > apply them?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > >
> > > 
> > > Hi Greg,
> > > I attached all the UIO patches I collected so far. This is my series file:
> > > 
> > > uio.patch
> > > fix-early-irq-problem-in-uio.patch
> > > uio-documentation.patch
> > > fix-uio_read-type-problem.patch
> > > uio-dummy.patch
> > > uio-hilscher-cif-card-driver.patch
> > > ioremap-in-uio-hilscher-cif.patch
> > > add-userspace-howto-to-uio-doc.patch
> > > fix-uio-doc-build-problems.patch
> > > 
> > > It should also work without uio-dummy.patch.
> > > I added Randy's last one-line patch to fix-uio-doc-build-problems.patch.
> > > 
> > > All patches are
> > > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> > > 
> > > fix-uio-doc-build-problems.patch is also
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > 
> > I also updated the original patch set with all these changes. They can be 
> > found here:
> > 
> > http://www.osadl.org/projects/downloads/UIO/kernel/
> 
> Can one of you make sure that Andrew has a version in -mm that
> will build without bombing?  

Andrew usually takes Greg's patches AFAIK. The patches in
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver/
are definitely out of date. Greg, could you update them?

> Current 2.6.21-mm1 does this on UIO docs, 
> but all of these have been fixed via email AFAIK:
> 
> Warning(/tester/linsrc/linux-2621-mm1//drivers/uio/uio.c:240): No description found for parameter 'info'
> Warning(/tester/linsrc/linux-2621-mm1//drivers/uio/uio.c:594): No description found for parameter 'owner'
> Warning(/tester/linsrc/linux-2621-mm1//drivers/uio/uio.c:594): No description found for parameter 'info'
> Warning(/tester/linsrc/linux-2621-mm1//drivers/uio/uio.c:667): No description found for parameter 'info'
> Error(/tester/linsrc/linux-2621-mm1//include/linux/uio_driver.h:29): cannot understand prototype: 'struct uio_mem '
> Error(/tester/linsrc/linux-2621-mm1//include/linux/uio_driver.h:55): cannot understand prototype: 'struct uio_info '
> Warning(/tester/linsrc/linux-2621-mm1//include/linux/uio_driver.h): no structured comments found
> make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 2
> make: *** [mandocs] Error 2

Yes, all of these are fixed in the patches I sent.

Thanks,
Hans


