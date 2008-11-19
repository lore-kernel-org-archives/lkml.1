Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYKSTKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYKSTKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYKSTKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:10:24 -0500
Received: from kroah.org ([198.145.64.141]:38800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752884AbYKSTKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:10:24 -0500
Date: Wed, 19 Nov 2008 11:08:37 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 19 (staging/go7007/)
Message-ID: <20081119190837.GA14574@kroah.com>
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au> <20081119104851.661efd27.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119104851.661efd27.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 10:48:51AM -0800, Randy Dunlap wrote:
> On Wed, 19 Nov 2008 17:59:17 +1100 Stephen Rothwell wrote:
> 
> > Dropped trees (temporarily):
> > 	driver-core (build problem)
> > 	usb (depends on driver-core)
> > 	userns (it depends on creds)
> > 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> > 	staging (depends on usb)
> 
> eh?
> 
> drivers/staging/go7007/go7007-v4l2.c:1338: error: too many arguments to function 'video_usercopy'
> 
> config attached.

That's due to the portions of the staging tree that is in Linus's tree,
interacting with the v4l tree here.  It's fixed in my staging tree that
normally gets into -next :)

thanks,

greg k-h
