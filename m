Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbYBAX4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbYBAX4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbYBAXz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:55:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbYBAXz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:55:59 -0500
Date: Fri, 1 Feb 2008 15:34:09 -0800
From: Greg KH <greg@kroah.com>
To: Stefan Roese <sr@denx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pci: Fix bus resource assignment on 32 bits with
	64b resources
Message-ID: <20080201233409.GB24676@kroah.com>
References: <20071210063216.89DBBDDE1E@ozlabs.org> <200802011118.57610.sr@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802011118.57610.sr@denx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 11:18:56AM +0100, Stefan Roese wrote:
> On Monday 10 December 2007, Benjamin Herrenschmidt wrote:
> > The current pci_assign_unassigned_resources() code doesn't work properly
> > on 32 bits platforms with 64 bits resources. The main reason is the use
> > of unsigned long in various places instead of resource_size_t.
> >
> > This fixes it, along with some tricks to avoid casting to 64 bits on
> > platforms that don't need it in every printk around.
> >
> > This is a pre-requisite for making powerpc use the generic code instead of
> > its own half-useful implementation.
> >
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Checking Linus's latest git repository, it seems this patch (and the 2nd from 
> this series) hasn't been applied till now. This is just a reminder, that it 
> gets in in this merge-window.

Just got sent to him...

thanks,

greg k-h
