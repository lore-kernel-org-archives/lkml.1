Return-Path: <linux-kernel-owner+w=401wt.eu-S1765052AbXEYVr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765052AbXEYVr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932126AbXEYVq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:46:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:43189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119AbXEYVqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:46:55 -0400
Date: Fri, 25 May 2007 14:40:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2 built on ppc (1)
Message-ID: <20070525214040.GB6925@suse.de>
References: <20070520110419.GB3253@aragorn.home.lxtec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520110419.GB3253@aragorn.home.lxtec.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 01:04:19PM +0200, Elimar Riesebieter wrote:
> Hi,
> 
> FYI, building 2.6.22-rc2 with
> gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
> on my powerbook (PPC) gives:
> 
> ...
> arch/powerpc/kernel/pci_32.c: In function 'pcibios_assign_resources':
> arch/powerpc/kernel/pci_32.c:562: warning: ignoring return value of 'pci_assign_resource', declared with attribute warn_unused_result
> arch/powerpc/kernel/pci_32.c: In function 'pcibios_add_platform_entries':
> arch/powerpc/kernel/pci_32.c:1053: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result
> arch/powerpc/mm/mem.c: In function 'paging_init':
> arch/powerpc/mm/mem.c:313: warning: passing argument 1 of 'pmd_offset' from incompatible pointer type
> arch/powerpc/mm/mem.c:316: warning: passing argument 1 of 'pmd_offset' from incompatible pointer type
> ...
> drivers/base/core.c: In function 'device_add':
> drivers/base/core.c:714: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/core.c:719: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/core.c:722: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/core.c: In function 'device_rename':
> drivers/base/core.c:1197: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> drivers/base/dd.c:211: warning: 'device_probe_drivers' defined but not used
> ...
> drivers/ide/setup-pci.c: In function 'ide_scan_pcibus':
> drivers/ide/setup-pci.c:879: warning: ignoring return value of '__pci_register_driver', declared with attribute warn_unused_result
> drivers/pci/search.c: In function 'pci_find_slot':
> drivers/pci/search.c:99: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:477)
> drivers/pci/search.c: At top level:
> drivers/pci/search.c:433: warning: 'pci_find_device' is deprecated (declared at drivers/pci/search.c:241)
> drivers/pci/search.c:433: warning: 'pci_find_device' is deprecated (declared at drivers/pci/search.c:241)
> ...
> 
> If more info is needed, please contact me via PM, as I am not
> subscribed.

I see some warnings, but no errors, right?  The pci and driver core
warnings are known and are being worked on...

thanks,

greg k-h
