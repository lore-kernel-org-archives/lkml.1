Return-Path: <linux-kernel-owner+w=401wt.eu-S1763828AbXJOG0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763828AbXJOG0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXJOG0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:26:03 -0400
Received: from www.tglx.de ([62.245.132.106]:37503 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbXJOG0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:26:01 -0400
Date: Mon, 15 Oct 2007 08:24:46 +0200
From: =?ISO-8859-15?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] doc: add uio document to docbook compilation target
Message-ID: <20071015082446.009956f4@dilbert.local>
In-Reply-To: <20071014204942.4f35de93.randy.dunlap@oracle.com>
References: <87k5ppffky.wl%takeuchi_satoru@jp.fujitsu.com>
	<20071014204942.4f35de93.randy.dunlap@oracle.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sun, 14 Oct 2007 20:49:42 -0700
schrieb Randy Dunlap <randy.dunlap@oracle.com>:

> On Mon, 15 Oct 2007 08:21:01 +0900 Satoru Takeuchi wrote:
> 
> > Add uio document to DocBook compilation target.
> > 
> > `make *docs' doesn't generate "The Userspace I/O HOWTO", the user
> > space I/O document written in DocBook.

True. Thanks for your help.

> > 
> > Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> > 
> > Index: linux/Documentation/DocBook/Makefile
> > ===================================================================
> > --- linux.orig/Documentation/DocBook/Makefile	2007-10-12
> > 23:54:19.000000000 +0900 +++
> > linux/Documentation/DocBook/Makefile	2007-10-12
> > 23:55:14.000000000 +0900 @@ -11,7 +11,7 @@ DOCBOOKS := wanbook.xml
> > z8530book.xml mc procfs-guide.xml writing_usb_driver.xml \
> > kernel-api.xml filesystems.xml lsm.xml usb.xml \ gadget.xml
> > libata.xml mtdnand.xml librs.xml rapidio.xml \
> > -	    genericirq.xml
> > +	    genericirq.xml uio-howto.xml
> >  
> >  ###
> >  # The build process is as follows (targets):
> 
> Hi,
> 
> Thanks, looks reasonable, but patch does not apply cleanly to
> mainline or -mm.  (trivial to fix)
> 
> ---
> ~Randy

Here's a version against mainline 2.6.23:

Thanks,
Hans

--
Add uio document to DocBook compilation target.

`make *docs' doesn't generate "The Userspace I/O HOWTO", the user
space I/O document written in DocBook.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>

Index: linux-2.6.23/Documentation/DocBook/Makefile
===================================================================
--- linux-2.6.23.orig/Documentation/DocBook/Makefile	2007-10-15 08:05:35.000000000 +0200
+++ linux-2.6.23/Documentation/DocBook/Makefile	2007-10-15 08:07:56.000000000 +0200
@@ -11,7 +11,7 @@
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml
+	    genericirq.xml uio-howto.xml
 
 ###
 # The build process is as follows (targets):
