Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbYCGBa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbYCGBa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 20:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbYCGBaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 20:30:15 -0500
Received: from lixom.net ([66.141.50.11]:34219 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbYCGBaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 20:30:14 -0500
Date: Thu, 6 Mar 2008 19:35:48 -0600
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: hskinnemoen@atmel.com, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       pasemi-linux@ozlabs.org, dan.j.williams@intel.com
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip DMA
	engine
Message-ID: <20080307013548.GA4965@lixom.net>
References: <20080306233900.GA3969@lixom.net> <20080307113150.c0874344.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307113150.c0874344.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 11:31:50AM +1100, Stephen Rothwell wrote:
> Hi Olof,
> 
> Just one thing I noticed ...
> 
> On Thu, 6 Mar 2008 17:39:00 -0600 Olof Johansson <olof@lixom.net> wrote:
> >
> > +	dma_dev->device_dependency_added = pasemi_dma_dependency_added;
> 
> device_dependency_added is going away in 2.6.26 ...

Thanks, I guess I need to base this on top of both powerpc and the
async-tx git trees and just merge it late.


-Olof
