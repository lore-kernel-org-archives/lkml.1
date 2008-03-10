Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYCJQLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYCJQLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYCJQLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:11:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572AbYCJQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:11:06 -0400
Date: Mon, 10 Mar 2008 09:09:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chandru <chandru@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, jdmason@kudzu.us,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
 in kdump
Message-Id: <20080310090912.b9f34d27.akpm@linux-foundation.org>
In-Reply-To: <47D5359D.5000909@in.ibm.com>
References: <1191962414.24134.68.camel@chandru>
	<20071009210623.GK4335@rhun.haifa.ibm.com>
	<20071010053057.GA24434@in.ibm.com>
	<20071014054110.GB4399@rhun.haifa.ibm.com>
	<20071015062919.GA4598@in.ibm.com>
	<476F4064.8010601@in.ibm.com>
	<47D5359D.5000909@in.ibm.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 18:50:29 +0530 Chandru <chandru@in.ibm.com> wrote:

> Chandru wrote:
> > Hi Muli,
> >
> > I have tried to work with CCR ,CSR, CSMR, CSAR, CFGRW, GBRERRM  
> > registers but have been unable to make calgary generate an exception 
> > upon error condition.  In alloc_tce_table() , I am setting WRITE_ONLY 
> > access permission bit to tce entries but it isn't helping.  Would you 
> > kindly let me know how we can make calgary to generate an exception in 
> > error conditions ?.
> >
> > Thanks,
> > Chandru
> >
> >
> Hello Andrew,
> 
> Could you pls consider the attached patch for inclusion in mainline.
> 

I can sort-of work out what the patch does from the above quote, but it
would be nice to have a proper changelog description from yourself rather
than having me try to write it, please.

> 
> Signed-off-by: Chandru S <chandru@in.ibm.com>
> ---
> 
> --- arch/x86/kernel/pci-calgary_64.c.orig       2008-03-10 
> 15:54:08.000000000 +0530

The patch was badly wordwrapped.  Please fix your email client for the next
version.

