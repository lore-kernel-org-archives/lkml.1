Return-Path: <linux-kernel-owner+w=401wt.eu-S1945925AbXDLHpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925AbXDLHpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945927AbXDLHpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:45:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56461 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945925AbXDLHpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:45:34 -0400
Date: Thu, 12 Apr 2007 00:18:15 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 12/14 UPDATED] sysfs: implement sysfs_dirent active
	reference and immediate disconnect
Message-ID: <20070412071815.GD13047@kroah.com>
References: <11760923261269-git-send-email-htejun@gmail.com> <11760923292724-git-send-email-htejun@gmail.com> <20070411041515.GA10619@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411041515.GA10619@htj.dyndns.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 01:15:15PM +0900, Tejun Heo wrote:
> [PATCH] sysfs: implement sysfs_dirent active reference and immediate disconnect

For some reason, this doesn't apply on top of your patches:

Applying patch sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
patching file fs/sysfs/dir.c
patching file fs/sysfs/sysfs.h
patching file fs/sysfs/bin.c
patching file fs/sysfs/file.c
Hunk #1 succeeded at 96 (offset 8 lines).
Hunk #2 succeeded at 107 (offset 8 lines).
Hunk #3 succeeded at 240 (offset 8 lines).
Hunk #4 FAILED at 300.
Hunk #5 succeeded at 336 (offset 14 lines).
Hunk #6 succeeded at 368 (offset 14 lines).
Hunk #7 succeeded at 435 (offset 14 lines).
1 out of 7 hunks FAILED -- rejects in file fs/sysfs/file.c
patching file fs/sysfs/inode.c

So I'll only apply the first 11 for now.  Can you respin the last 3 and
send them to me again?

thanks,

greg k-h
