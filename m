Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbZJISbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbZJISbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761314AbZJISbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:31:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761299AbZJISbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:31:49 -0400
Date: Fri, 9 Oct 2009 11:08:34 -0700
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Staging: comedi: Add include of <linux/sched.h> to fix build
Message-ID: <20091009180834.GA3462@suse.de>
References: <adamy40jwge.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamy40jwge.fsf@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 10:42:09AM -0700, Roland Dreier wrote:
> Commit a99bbaf5 ("headers: remove sched.h from poll.h") removed the
> implicit include of <linux/sched.h> via <linux/poll.h>, and broke the
> comedi build with errors like:
> 
>     drivers/staging/comedi/drivers/serial2002.c:201: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> 
> Explicitly include <linux/sched.h> to fix this.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Heh, this is already in my tree, and will be sent to Linus today.

thanks,

greg k-h
