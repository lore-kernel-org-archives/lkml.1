Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128Ab0AVSXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0AVSXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078Ab0AVSXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:23:12 -0500
Received: from xenotime.net ([72.52.64.118]:56303 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755985Ab0AVSXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:23:11 -0500
Date: Fri, 22 Jan 2010 10:23:08 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: Introduction to rar_register patch set of 5 patches
Message-Id: <20100122102308.bb17fd1a.rdunlap@xenotime.net>
In-Reply-To: <1264182811-28933-1-git-send-email-mark.a.allyn@intel.com>
References: <1264182811-28933-1-git-send-email-mark.a.allyn@intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 09:53:30 -0800 Mark Allyn wrote:

> The following five patches are for the Restricted Access Region
> Register (rar_register) driver.
> 
> This driver is for the Intel MID platform.

Hi Mark,

Please read and try to follow Documentation/SubmittingPatches.

E.g.:

"The canonical patch subject line is:

    Subject: [PATCH 001/123] subsystem: summary phrase"

so your patch 1 should be more like:

[PATCH 1/5] rar_register: rename rar_driver to rar_register

and then that one patch's description should be at the top of that
email's body, not in the patch introduction/cover email.

As it stands, these 5 patch descriptions need to be moved
to each patch's patch description...


> There are five patches. They are:
> 
> Patch 1 of 5 for rar_register; renaming to rar_register
> 	This renames the current rar resigter driver to
> 	the name rar_register. This is to differentiate
> 	it from the rar_handler driver, which will be
> 	submitted later.
> Patch 2 of 5 for rar_register - renaming directory to rar_register
> 	This renames the directory in which the driver files
> 	are located; again for clarity.
> Patch 3 of 5 for rar_register - provide better explanation in Kconfig
> 	This patch provides a better explanation of what this
> 	driver is for in the Kconfig file
> Patch 4 of 5 for rar_register - fix checkpatch errors and debug header
> 	This patch cleans up checkpatch errors and warnings as well as
> 	fixes bugs in the rar_register.h header file
> Patch 5 of 5 for rar_register - fix checkpatch errors and debug program file
> 	This patch cleans up checkpatch errors and warnings as well as
> 	fixes bugs in the rar_register.c program file
> 
> Please note that patches 1, 2, and 3 are for 'housekeeping'. They do nothing
> to correct any checkpatch errors/warnings in the driver.
> 
> Patches 4 and 5 clean up checkpatch issues in the rar_register.h and
> rar_register.c file respectively.
> 
> After patch 5 is applied, there should be no checkpatch issues in the entire
> driver directory
> 
> 
> Please note that I did a test build of this patch set after patch 3 and after
> patch 5 of this set.
> 
> If there are issues with either patch 4 or patch 5, you can still submit 
> patches 1, 2, and 3 and expect a clean build.
> 
> These patches were applied against the kernel next that I pulled as of Wednesday, 
> January 21, 2010.


Thanks,
---
~Randy
