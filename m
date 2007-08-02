Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbXHBA0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbXHBA0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXHBA00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:26:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40013 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXHBA0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:26:25 -0400
Date: Wed, 1 Aug 2007 17:29:00 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu
Subject: Re: [PATCH 1/7] sysfs: fix locking in sysfs_lookup() and
	sysfs_rename_dir()
Message-ID: <20070802002900.GA16784@kroah.com>
References: <11858769082982-git-send-email-htejun@gmail.com> <1185876908509-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185876908509-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 07:15:08PM +0900, Tejun Heo wrote:
> sd children list walking in sysfs_lookup() and sd renaming in
> sysfs_rename_dir() were left out during i_mutex -> sysfs_mutex
> conversion.  Fix them.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

Ok, to apply this, it messes with Eric's further patches for the shadow
directory stuff.  But since it looks like you and Eric seem to have
worked something else in that area, I'll drop Eric's patches for now, as
that's the safest thing.

Eric, is that ok?

thanks,

greg k-h
