Return-Path: <linux-kernel-owner+w=401wt.eu-S933469AbZJFVeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbZJFVeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933458AbZJFVeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:22 -0400
Received: from kroah.org ([198.145.64.141]:55779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933456AbZJFVeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:21 -0400
Date: Tue, 6 Oct 2009 14:29:36 -0700
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Changes to integrate RAR with SEP and fix RAR problems
Message-ID: <20091006212936.GA21996@kroah.com>
References: <1254861953-18099-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254861953-18099-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 01:45:53PM -0700, Mark Allyn wrote:
> SEP stands for Security Processor; a dedicated processor
> that does encryption, decryption, key management, and
> secure storage.
> 
> RAR stands for Restricted Access Region; this is memory
> aboard the MID platform that is restricted (via hardware)
> from access by software running on the x86 processor.
> Dedicated 'smart' peripherals such as sound, video, and
> encryption can access these regions of memory. They are here
> to help protect copyrighted midia from being illegally copied.

How does it allow "fair-use" copying?  To prevent that is considered
illegal in some juristictions :)

> This is upstream revision 4 of the RAR driver.
> 
> This is a patch referenced from the linux-next repository
> as pulled on October 6, 2009; from the following URL:

Why are you deleting the existing driver entirely?  Why not just patch
it to have whatever new things you need here?

> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> This is a modified RAR driver to include integration with
> the SEP driver
> 
> Plese be aware that the SEP driver requires this driver
> in order to compile and run. There are API function calls
> within this driver that are required by the SEP driver.
> 
> Other drivers being developed in the future will also 
> require this driver.

What drivers?  In what way will it be required?

Your patch contains a number of obvious problems that
scripts/checkpatch.pl would have caught.  Please run it through that
before submitting it again.

I'll not take this version for the above reasons.

thanks,

greg k-h
