Return-Path: <linux-kernel-owner+w=401wt.eu-S933533AbZJFVfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbZJFVfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933468AbZJFVeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:23 -0400
Received: from kroah.org ([198.145.64.141]:55782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933457AbZJFVeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:22 -0400
Date: Tue, 6 Oct 2009 14:30:42 -0700
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Integrating SEP Driver with RAR Driver
Message-ID: <20091006213042.GB21996@kroah.com>
References: <1254861977-18123-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254861977-18123-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 01:46:17PM -0700, Mark Allyn wrote:
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
> 
> This is upstream revision 4 of the SEP driver.
> 
> This is a patch referenced from the linux-next repository
> as pulled on October 6, 2009; from the following URL:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> This is a modified SEP driver to include integration with
> the RAR driver
> 
> The SEP uses a region of restricted memory to hold its own
> firmware; protecting that firmware and it's operation by
> snooping via the x86 software.
> 
> Please be aware that this patch does not contain any encryption
> algorithm. It only transports data to and from user space
> applications to the security processor.
> 
> Please be aware that the SEP does require propriatary firmware;
> however, the firmware is not within the kernel. It is to be
> located in /lib/firmware and loaded by the normal kernel
> firmware infrastructure using the request_firmware() kernel
> api function call.

Is this firmware in the linux-firmware package already?  If not, why
not?

Why are you adding new functionality to this driver when it is not yet
cleaned up and moved out of the staging tree?  Please work to get it
cleaned up and merged first.

thanks,

greg k-h
