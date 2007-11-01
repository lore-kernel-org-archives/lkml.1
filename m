Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbXKAPhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbXKAPhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbXKAPho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:37:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:52121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353AbXKAPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:37:44 -0400
Date: Thu, 1 Nov 2007 08:40:44 -0700
From: Greg KH <gregkh@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] 2.6.24-rc1-git8 build fails drivers/pci/probe.c
Message-ID: <20071101154044.GA12833@suse.de>
References: <47283A53.6060800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47283A53.6060800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 01:48:27PM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> The 2.6.24-rc-git8 build fails with build error
> 
>   CC      drivers/pci/probe.o
> drivers/pci/probe.c: In function 'pci_create_legacy_files':
> drivers/pci/probe.c:56: error: implicit declaration of function 'class_device_create_bin_file'
> drivers/pci/probe.c: In function 'pci_remove_legacy_files':
> drivers/pci/probe.c:71: error: implicit declaration of function 'class_device_remove_bin_file'
> make[2]: *** [drivers/pci/probe.o] Error 1
> make[1]: *** [drivers/pci] Error 2
> make: *** [drivers] Error 2
> 
> This is caused by the commit fcd239d3d5575e5cc63aab5c33cf6dc66904f6d6 (Driver core: remove class_device_*_bin_file).
> These functions are still being used by drivers/pci/probe.c.

Thanks for the report, Linus's tree now has a fix for this oversight on
my behalf.

greg k-h
