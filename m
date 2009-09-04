Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbZIDFVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbZIDFVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932159AbZIDFVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:21:12 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36656 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbZIDFVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:21:11 -0400
Date: Fri, 4 Sep 2009 10:51:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix missing include file in RTL8192U staging driver
Message-ID: <20090904052107.GA4883@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090903115213.GA4315@linux.vnet.ibm.com> <20090903180453.GA25231@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090903180453.GA25231@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de> [2009-09-03 11:04:53]:

> On Thu, Sep 03, 2009 at 05:22:13PM +0530, Kamalesh Babulal wrote:
> > Hi Greg,
> > 
> > 	2.6.31-rc8 build fails with
> > 
> > drivers/staging/rtl8192su/r8192U_core.c:5086: error: implicit declaration of function 'vmalloc'
> > drivers/staging/rtl8192su/r8192U_core.c:5086: warning: cast to pointer from integer of different size
> > drivers/staging/rtl8192su/r8192U_core.c: In function 'rtl8192_usb_disconnect':
> > drivers/staging/rtl8192su/r8192U_core.c:12308: error: implicit declaration of function 'vfree'
> > 
> > Including the vmalloc.h file, fixes the build failure. I have tested the
> > patch for build failure only.
> 
> On what arch are you hitting this?

It's on powerpc.
> 
> This should all be resolved in the linux-next tree, right?

Yes, linux-next tree already has a patch

commit 323308f10fc629d2276b6c97c5ecb9cdff0f5e65
Author: Jeff Mahoney <jeffm@suse.com>
Date:   Tue Aug 4 10:26:23 2009 -0400

    Staging: rtl8192su: add linux/vmalloc.h

sorry, which I missed.

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
			
			Kamalesh
