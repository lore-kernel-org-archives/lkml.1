Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab0BRWXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:23:18 -0500
Received: from kroah.org ([198.145.64.141]:52109 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0BRWXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:23:16 -0500
Date: Thu, 18 Feb 2010 14:22:15 -0800
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Biederman <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 7/8] ehci-dbgp: split PID register updates for IN and
 OUT pipes
Message-ID: <20100218222215.GA27855@kroah.com>
References: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com>
 <1266014369-29547-8-git-send-email-jason.wessel@windriver.com>
 <20100218000103.GI12197@kroah.com>
 <4B7DB912.70806@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7DB912.70806@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 04:02:58PM -0600, Jason Wessel wrote:
> Greg KH wrote:
> > On Fri, Feb 12, 2010 at 04:39:28PM -0600, Jason Wessel wrote:
> >   
> >> This patch addresses two problems:
> >>     
> >
> > Do you want me to take this patch, and 8/8 in my tree, or yours?
> >
> > If yours, please add a:
> > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > to the patch.
> >
> >   
> 
> 
> I added the Ack's.
> 
> I will keep the patches in my tree because unless the
> kernel-parameters.txt patch is split it will not apply cleanly for patch
> 8/8.  It currently depends on the kdb tree, even though the source code
> portions do not depend on anything.  If the early debug patch set is
> rejected for some reason, I'll fix patch 8/8 and submit it to your tree.

Sounds good.

> You might consider patch 7/8 for -stable because I observed the dbgp
> device no longer dropping any characters when there is a significant
> printk volume in a short period of time.

When the patch goes into Linus's tree, just send stable@kernel.org the
git commit id of the patch and I will add it.

Or you can add:
	Cc: stable <stable@kernel.org>
to the signed-off-by area, and when it goes into Linus's tree, I will be
automatically notified about it, no need for you to do anything else.

thanks,

greg k-h
