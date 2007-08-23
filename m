Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbXHWJ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbXHWJ5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbXHWJ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:57:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47587 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbXHWJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:57:31 -0400
Date: Thu, 23 Aug 2007 02:50:30 -0700
From: Greg KH <greg@kroah.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs_remove_bin_file: bad dentry or inode or no such file:
	"descriptors"
Message-ID: <20070823095030.GA6504@kroah.com>
References: <20070816081458.GA24671@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816081458.GA24671@aepfle.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 10:14:58AM +0200, Olaf Hering wrote:
> 
> This sysfs_remove_bin_file message appears sometimes on my dualcore G5.
> I think only during cold boot.

Fixed in a patch that was sent to Linus earlier today.  It's safe to
ignore this, it's only a warning.

thanks,

greg k-h
