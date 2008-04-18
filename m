Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYDRQ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYDRQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYDRQ7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:59:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41636 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYDRQ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:59:09 -0400
Date: Fri, 18 Apr 2008 09:56:41 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (build error: driver core)
Message-ID: <20080418165641.GC21168@kroah.com>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <20080418094041.86b082bb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418094041.86b082bb.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 09:40:41AM -0700, Randy Dunlap wrote:
> On Fri, 18 Apr 2008 01:47:57 -0700 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/ 
> 
> with CONFIG_BLOCK=n:
> 
> linux-2.6.25-mm1/drivers/base/core.c: In function 'device_to_dev_kobj':
> linux-2.6.25-mm1/drivers/base/core.c:768: error: 'block_class' undeclared (first use in this function)
> make[3]: *** [drivers/base/core.o] Error 1

Ah, more fun caused by Dan's /sys/dev/... patch.

Dan, this is causing a lot of problems, I'm going to drop it for now
until the build and run-time errors get resolved.

thanks,

greg k-h
