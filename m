Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382Ab0ASAPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0ASAPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940Ab0ASAPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:15:15 -0500
Received: from kroah.org ([198.145.64.141]:57297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab0ASAPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:15:14 -0500
Date: Mon, 18 Jan 2010 16:12:05 -0800
From: Greg KH <greg@kroah.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
       alan@linux.intel.com, charles.f.johnson@intel.com
Subject: Re: [PATCH] Rename rar_driver to rar_register
Message-ID: <20100119001205.GC27551@kroah.com>
References: <1263849696-23060-1-git-send-email-mark.a.allyn@intel.com>
 <1263851158.5591.147.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263851158.5591.147.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 01:45:58PM -0800, Marcel Holtmann wrote:
> Hi Mark,
> 
> > The purpose of this patch is to change the name of rar_register source
> > files (both the .c and .h files) to rar_register.
> > 
> > This is the first of seven patches for the rar_register driver
> > for Sunday, January 17, 2009
> > 
> > This is to clarify that this driver is for the rar_register.
> > 
> > This patch only changes the names. It does not make any changes in
> > any code.
> > 
> > Any checkpatch errors on this code were from the original code. They
> > will be addressed in future patches.
> > 
> > The rar stands for restricted access region. The restricted access
> > region is an area of memory that can be locked from access by the
> > x86 processor.
> > 
> > The purpose of the restricted access region is to safeguard confidential
> > information from any unauthorized software running on the x86 processor.
> > 
> > The purpose of this driver is to enable other drivers to obtain
> > the address ranges of the restricted regions as well as lock them.
> > 
> > This patch is referenced off the linux-next repository as pulled
> > on Sunday, January 17, 2010
> 
> this is a lot of boilerplate that you repeat for every patch in this
> series. It distracts from the actual change you are making. I would
> prefer if you send an introductory/summary email and then focus the
> commit message on the actual change you are making.

As the person who has to edit these commit messages down to nothing, I
totally agree.  Please follow the proper submission guidelines for
patches as described in the Documentation/ directory.

Can you resend all of these please based on that?

thanks,

greg k-h
