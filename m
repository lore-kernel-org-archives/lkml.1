Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZFDSOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZFDSOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZFDSN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:13:58 -0400
Received: from kroah.org ([198.145.64.141]:46243 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbZFDSN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:13:57 -0400
Date: Thu, 4 Jun 2009 11:07:36 -0700
From: Greg KH <greg@kroah.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig
	[drivers/staging/comedi/drivers.o]
Message-ID: <20090604180736.GA24902@kroah.com>
References: <20090604133132.19010.16577.sendpatchset@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090604133132.19010.16577.sendpatchset@subratamodak.linux.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 07:01:32PM +0530, Subrata Modak wrote:
> CC [M]  drivers/staging/comedi/drivers.o
> drivers/staging/comedi/drivers.c: In function ‘comedi_buf_alloc’:
> drivers/staging/comedi/drivers.c:496: error: ‘PAGE_KERNEL_NOCACHE’ undeclared (first use in this function)
> drivers/staging/comedi/drivers.c:496: error: (Each undeclared identifier is reported only once
> drivers/staging/comedi/drivers.c:496: error: for each function it appears in.)
> make[3]: *** [drivers/staging/comedi/drivers.o] Error 1
> make[2]: *** [drivers/staging/comedi] Error 2
> make[1]: *** [drivers/staging] Error 2
> make: *** [drivers] Error 2
> 
> Is it still normal to expect this failure ?

No.

> I reported them long back during April:
> http://www.gossamer-threads.com/lists/linux/kernel/1065227,

Yes, and I took some patches that were supposed to fix this.  I can't
duplicate this here, care to send a patch that would fix it?

thanks,

greg k-h
