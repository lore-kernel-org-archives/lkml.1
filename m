Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYJPT6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYJPT6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYJPT6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:58:22 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:51167 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbYJPT6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:58:21 -0400
Date: Fri, 17 Oct 2008 01:28:12 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
       apw@shadowen.org
Subject: Re: [PATCH] linux-next: Tree for October 16 - build failure at MAL
	support on powerpc
Message-ID: <20081016195812.GB7534@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081016211811.a523c8f2.sfr@canb.auug.org.au> <20081016192320.GA7534@linux.vnet.ibm.com> <20081016152755.2b95f80c@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081016152755.2b95f80c@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Boyer <jwboyer@linux.vnet.ibm.com> [2008-10-16 15:27:55]:

> On Fri, 17 Oct 2008 00:53:20 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > Hi Stephen,
> > 
> >         next-20081016 kernel build fails on powerpc, with build error
> > 
> > drivers/net/ibm_newemac/mal.c: In function 'mal_txeob':
> > drivers/net/ibm_newemac/mal.c:284: error: implicit declaration of function 'mtdcri'
> > drivers/net/ibm_newemac/mal.c:284: error: 'SDR0' undeclared (first use in this function)
> > drivers/net/ibm_newemac/mal.c:284: error: (Each undeclared identifier is reported only once
> > drivers/net/ibm_newemac/mal.c:284: error: for each function it appears in.)
> > drivers/net/ibm_newemac/mal.c:285: error: implicit declaration of function 'mfdcri'
> > drivers/net/ibm_newemac/mal.c: In function 'mal_rxeob':
> > drivers/net/ibm_newemac/mal.c:302: error: 'SDR0' undeclared (first use in this function)
> > make[3]: *** [drivers/net/ibm_newemac/mal.o] Error 1
> > 
> > Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> 
> I sent a more complete fix earlier today.
> 
> http://patchwork.ozlabs.org/patch/4708/
> 
> josh
Hi Josh,

Thanks, I missed your earlier posting today. The patch fixes the build failure
for me.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
