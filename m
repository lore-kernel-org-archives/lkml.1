Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbXIYVen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbXIYVen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbXIYVeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:34:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47784 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbXIYVeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:34:36 -0400
Date: Tue, 25 Sep 2007 14:32:32 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] sysfs: kill SYSFS_FLAG_REMOVED
Message-ID: <20070925213232.GA30973@kroah.com>
References: <11902719091692-git-send-email-htejun@gmail.com> <1190271909505-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190271909505-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 04:05:09PM +0900, Tejun Heo wrote:
> With sysfs_get_dentry() simplified, there's no user of
> SYSFS_FLAG_REMOVED left.  Kill it.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> This patch reverts driver/sysfs-kill-sysfs_flag_removed.patch and thus
> can be removed together with it.

Ok, I've just removed that original one so this isn't needed either.

thanks,

greg k-h
