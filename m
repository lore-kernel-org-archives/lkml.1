Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbXJaOvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbXJaOvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 10:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXJaOvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 10:51:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:46212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbXJaOvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 10:51:41 -0400
Date: Wed, 31 Oct 2007 07:34:41 -0700
From: Greg KH <gregkh@suse.de>
To: Denis Cheng <crquan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [sysfs]: make readlink result shorter when the symlink
	and its target shared some base sysfs subdirectory
Message-ID: <20071031143441.GA7128@suse.de>
References: <1193826860-6166-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193826860-6166-1-git-send-email-crquan@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 06:34:20PM +0800, Denis Cheng wrote:
> this is especially useful after /sys/slab introduced, for example:
> 
> $ ls -l /sys/slab/mm_struct
> lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> :0000448
> 
> instead of:
> 
> $ ls -l /sys/slab/mm_struct
> lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> ../slab/:0000448
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

As pretty as this change is, it's not really necessary, right?

Is there any other place in /sys that would benefit from this?

thanks,

greg k-h
