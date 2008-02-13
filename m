Return-Path: <linux-kernel-owner+w=401wt.eu-S933933AbYBMRjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbYBMRjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYBMRiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:38:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43387 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbYBMRiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:38:50 -0500
Date: Wed, 13 Feb 2008 09:33:22 -0800
From: Greg KH <greg@kroah.com>
To: Hans-J??rgen Koch <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UIO sysfs attributes broken in 2.6.25-rc1
Message-ID: <20080213173322.GD10733@kroah.com>
References: <20080213180304.4ffa81e9@dilbert.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213180304.4ffa81e9@dilbert.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 06:03:04PM +0100, Hans-J??rgen Koch wrote:
> In 2.6.25-rc1, there's a strange effect:
> Although the map attributes "addr" and "size" show up correctly:
> 
> -r--r--r-- 1 root root 4096 2008-02-13 17:49 addr
> -r--r--r-- 1 root root 4096 2008-02-13 17:49 size
> 
> you cannot access them, not even as root. Something like "cat addr"
> fails with a no-permission-error. It works fine in 2.6.24-rc8.
> 
> This is probably related to this patch:
> 
> http://lkml.org/lkml/2008/1/25/149
> 
> Unfortunately, I signed-off that one, too... I checked if all sysfs
> files appear, but didn't try to access them. Sorry.

Heh, well at least it wasn't just me that thought the patch was correct
:)

> Greg, any ideas?

I'll look into it this afternoon...

thanks,

greg k-h
