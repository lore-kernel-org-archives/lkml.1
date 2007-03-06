Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXCFKFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXCFKFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933184AbXCFKFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:05:12 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:10303 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933208AbXCFKFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:05:11 -0500
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 05:05:10 EST
Date: Tue, 6 Mar 2007 12:42:18 +0300
From: Vitaly Bordug <vbordug@ru.mvista.com>
To: "Li Yang-r58472" <LeoLi@freescale.com>
Cc: "Cedric Pontois" <cpontois@nortel.com>, <dmalek@jlc.net>,
       linux-kernel@vger.kernel.org, linuxppc-embedded@ozlabs.org
Subject: Re: [patch 1/1] ppc: Possible bug fix for FCC driver
Message-ID: <20070306124218.4bebc288@localhost.localdomain>
In-Reply-To: <989B956029373F45A0B8AF02970818902DA97B@zch01exm26.fsl.freescale.net>
References: <00B1F4365DDBE745B091C67A1CCFCB43070CE21E@zctfhxm1>
	<989B956029373F45A0B8AF02970818902DA97B@zch01exm26.fsl.freescale.net>
X-Mailer: Claws Mail 2.7.2cvs30 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 10:23:43 +0800
Li Yang-r58472 wrote:

> Hi Cedric,
> 
> For ppc embedded related patches, please also cc:
> linuxppc-embedded@ozlabs.org.
> 
> > We use a kernel 2.6.14 on PPC platform (MPC 8555). The FCC driver
> works
> 
> To submit a kernel patch upstream, the patch should be against the
> latest kernel version which is 2.6.21-rc now.
> > well with a 100Mbps link. But it doesn't with a 10Mbps link. To
> > solve it, I modified the GFMR register init: removed TCI bit and
> > set CRC32
> bit
> > instead of.
> 
> I don't know how these bits caused the 10M link issue.  Do you have
> any reasoning?
> 
> > 	Signed-off-by: Cedric Pontois <cpontois@nortel.com>
> > 
> >
> ------------------------------------------------------------------------
> > -----
> > 
> > diff -ruN pa-original/arch/ppc/8260_io/fcc_enet.c
The fcc code in 8260_io has been obsoleted by fs_enet driver (drivers/net/fs_enet).
It is known to work with 85xx at least in recent kernels. If it does not for some reason,
please letus know.

Thanks,

-Vitaly
