Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbXEGRoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbXEGRoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXEGRoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:44:04 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50969 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbXEGRoD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:44:03 -0400
Date: Mon, 7 May 2007 10:46:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       akpm <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-Id: <20070507104629.79185cb5.randy.dunlap@oracle.com>
In-Reply-To: <200705041137.09403.hjk@linutronix.de>
References: <20070427224957.GA17967@kroah.com>
	<20070503053731.GA17864@kroah.com>
	<200705030839.13675.hjk@linutronix.de>
	<200705041137.09403.hjk@linutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 11:37:09 +0200 Hans-Jürgen Koch wrote:

> Am Donnerstag 03 Mai 2007 08:39 schrieb Hans-Jürgen Koch:
> > > 
> > > Hm, I have about 3 different patches here now, all dependant on each
> > > other, yet I can't tell which goes first :(
> > > 
> > > Can someone just send me 1, or 3 with the correct order in which to
> > > apply them?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > >
> > 
> > Hi Greg,
> > I attached all the UIO patches I collected so far. This is my series file:
> > 
> > uio.patch
> > fix-early-irq-problem-in-uio.patch
> > uio-documentation.patch
> > fix-uio_read-type-problem.patch
> > uio-dummy.patch
> > uio-hilscher-cif-card-driver.patch
> > ioremap-in-uio-hilscher-cif.patch
> > add-userspace-howto-to-uio-doc.patch
> > fix-uio-doc-build-problems.patch
> > 
> > It should also work without uio-dummy.patch.
> > I added Randy's last one-line patch to fix-uio-doc-build-problems.patch.
> > 
> > All patches are
> > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> > 
> > fix-uio-doc-build-problems.patch is also
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> 
> I also updated the original patch set with all these changes. They can be 
> found here:
> 
> http://www.osadl.org/projects/downloads/UIO/kernel/

Can one of you make sure that Andrew has a version in -mm that
will build without bombing?  Current 2.6.21-mm1 does this on UIO docs,
but all of these have been fixed via email AFAIK:

Warning(/tester/linsrc/linux-2621-mm1//drivers/uio/uio.c:240): No description found for parameter 'info'
Warning(/tester/linsrc/linux-2621-mm1//drivers/uio/uio.c:594): No description found for parameter 'owner'
Warning(/tester/linsrc/linux-2621-mm1//drivers/uio/uio.c:594): No description found for parameter 'info'
Warning(/tester/linsrc/linux-2621-mm1//drivers/uio/uio.c:667): No description found for parameter 'info'
Error(/tester/linsrc/linux-2621-mm1//include/linux/uio_driver.h:29): cannot understand prototype: 'struct uio_mem '
Error(/tester/linsrc/linux-2621-mm1//include/linux/uio_driver.h:55): cannot understand prototype: 'struct uio_info '
Warning(/tester/linsrc/linux-2621-mm1//include/linux/uio_driver.h): no structured comments found
make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 2
make: *** [mandocs] Error 2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
