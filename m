Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYIFFT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYIFFT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYIFFTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:19:20 -0400
Received: from smtp.nokia.com ([192.100.122.230]:56803 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYIFFTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:19:19 -0400
Date: Sat, 06 Sep 2008 08:18:41 +0300 (EEST)
Message-Id: <20080906.081841.03994201.Hiroshi.DOYU@nokia.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH] Add missing macro argument for devm_release_* family
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20080905185254.78706060.akpm@linux-foundation.org>
References: <1220662823-19106-1-git-send-email-Hiroshi.DOYU@nokia.com>
	<20080905185254.78706060.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Sep 2008 05:18:43.0812 (UTC) FILETIME=[0800A240:01C90FE0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "ext Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add missing macro argument for devm_release_* family
Date: Fri, 5 Sep 2008 18:52:54 -0700

> On Sat,  6 Sep 2008 04:00:23 +0300 Hiroshi DOYU <Hiroshi.DOYU@nokia.com> wrote:
> 
> > From: ext Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> > 
> > Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> > ---
> >  include/linux/ioport.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> > index 22d2115..c813c63 100644
> > --- a/include/linux/ioport.h
> > +++ b/include/linux/ioport.h
> > @@ -158,9 +158,9 @@ extern struct resource * __devm_request_region(struct device *dev,
> >  				struct resource *parent, resource_size_t start,
> >  				resource_size_t n, const char *name);
> >  
> > -#define devm_release_region(start,n) \
> > +#define devm_release_region(dev,start,n) \
> >  	__devm_release_region(dev, &ioport_resource, (start), (n))
> > -#define devm_release_mem_region(start,n) \
> > +#define devm_release_mem_region(dev,start,n) \
> >  	__devm_release_region(dev, &iomem_resource, (start), (n))
> >  
> >  extern void __devm_release_region(struct device *dev, struct resource *parent,
> 
> um, OK.
> 
> But none of these things appear to have any callers anywhere.  Why
> don't we just delete it all?

Not sure for others, but at least, I am using this in my developing
driver;)
