Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYHNPrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYHNPrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYHNPrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:47:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:53880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYHNPrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:47:21 -0400
Date: Thu, 14 Aug 2008 08:44:56 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, ak@linux.intel.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Message-ID: <20080814154456.GA26388@kroah.com>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <20080814083828.d10e126d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814083828.d10e126d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 08:38:28AM -0700, Randy Dunlap wrote:
> calling  param_sysfs_init+0x0/0x1e7
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
> sysfs: duplicate filename 'acpi' can not be created

Why would this be a sysfs error, it's acpi doing something foolish,
that's why the sysfs layer is warning about it :)

thanks,

greg k-h
