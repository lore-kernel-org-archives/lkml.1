Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0CIAAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:00:13 -0500
Received: from kroah.org ([198.145.64.141]:35532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab0CIAAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:00:10 -0500
Date: Mon, 8 Mar 2010 15:59:53 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] i2c: update for semaphore to mutex conversion of
 devices
Message-ID: <20100308235953.GA7808@kroah.com>
References: <20100309102828.18351564.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309102828.18351564.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 10:28:28AM +1100, Stephen Rothwell wrote:
> I have been carrying this patch in linux-next for some time and now
> mainline needs it.

Well, it's not required, but it is nice to have.  I didn't merge the
"convert the driver core semaphore to a mutex" patch as it was causing
too many false-positive lockdep warnings.

Hopefully the lockdep core will be tweaked to handle the locking tree
that the device core requires and then when that happens, I will merge
the patch that will require this fix in order to keep the build from
breaking.

But for now, it's not a requirement, although, it does make my life
easier.

thanks,

greg k-h
