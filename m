Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXFYV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXFYV5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbXFYV4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:56:35 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50628 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXFYV4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:56:34 -0400
Date: Mon, 25 Jun 2007 14:25:43 -0700
From: Greg KH <greg@kroah.com>
To: dougthompson@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fs-sysfs bugfix of sysfs_hash_and_remove
	dereferencing before checking for NULL
Message-ID: <20070625212543.GB13415@kroah.com>
References: <887490.81074.qm@web50106.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <887490.81074.qm@web50106.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 10:13:24AM -0700, Doug Thompson wrote:
> From:	Douglas Thompson <dougthompson@xmission.com>
> 
> In tracking down one of my bugs in using sysfs, I found the kernel doing a NULL de-reference
> in function fs/sysfs/inode.c:sysfs_hash_and_remove(), when I (incorrectly) passed
> in a dentry value of NULL.
> 
> The check for NULL should occur BEFORE the dereference of 'dir'. 
> This patch modifies the sequence and does the check FIRST
> 
> 
> Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
> ---
> 
> Index: linux-2.6.22-rc4-mm2/fs/sysfs/inode.c

There's been a lot of churn and change in this area and this patch
doens't apply anymore.  Can you try respinning it against the next -mm
release and resending it if it is still needed?

thanks,

greg k-h

