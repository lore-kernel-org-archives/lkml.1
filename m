Return-Path: <linux-kernel-owner+w=401wt.eu-S1031286AbXDZPZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031286AbXDZPZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXDZPZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:25:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54941 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031286AbXDZPY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:24:58 -0400
Date: Thu, 26 Apr 2007 08:22:21 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: use different lockdep subclass for s_active
	deactivation
Message-ID: <20070426152221.GB16563@kroah.com>
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com> <462EE4B7.6000708@gmail.com> <20070426145047.GF17130@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426145047.GF17130@htj.dyndns.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 11:50:47PM +0900, Tejun Heo wrote:
> A sysfs node can delete other sysfs files when accessed.  This results
> in recursive s_active locking - read lock for file access, down lock
> of the vicitim for deactivation.  Tell lockdep that it's okay.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> Miles, please test this patch.  It should remove the lockdep warning.
> Fixes for the other two problems will soon follow.
> 
> Greg, Andrew, after all the fixes are verified, I'll merge the fixes
> into the original patches and resend all the sysfs updates in better
> shape.  Sorry about all the trouble.

Thanks, that will make it easier for me, as I've seen a lot of them go
floating by recently :)

greg k-h
