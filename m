Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbXJODu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbXJODu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 23:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXJODuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 23:50:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38580 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbXJODuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 23:50:16 -0400
Date: Sun, 14 Oct 2007 20:49:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       hjk@linutronix.de
Subject: Re: [PATCH] doc: add uio document to docbook compilation target
Message-Id: <20071014204942.4f35de93.randy.dunlap@oracle.com>
In-Reply-To: <87k5ppffky.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87k5ppffky.wl%takeuchi_satoru@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 08:21:01 +0900 Satoru Takeuchi wrote:

> Add uio document to DocBook compilation target.
> 
> `make *docs' doesn't generate "The Userspace I/O HOWTO", the user space
> I/O document written in DocBook.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> Index: linux/Documentation/DocBook/Makefile
> ===================================================================
> --- linux.orig/Documentation/DocBook/Makefile	2007-10-12 23:54:19.000000000 +0900
> +++ linux/Documentation/DocBook/Makefile	2007-10-12 23:55:14.000000000 +0900
> @@ -11,7 +11,7 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
>  	    procfs-guide.xml writing_usb_driver.xml \
>  	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
>  	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
> -	    genericirq.xml
> +	    genericirq.xml uio-howto.xml
>  
>  ###
>  # The build process is as follows (targets):

Hi,

Thanks, looks reasonable, but patch does not apply cleanly to
mainline or -mm.  (trivial to fix)

---
~Randy
