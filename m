Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZLIUkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZLIUkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbZLIUkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:40:24 -0500
Received: from kroah.org ([198.145.64.141]:43990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842AbZLIUkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:40:13 -0500
Date: Wed, 9 Dec 2009 12:30:02 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: staging tree build failure
Message-ID: <20091209203002.GB8222@kroah.com>
References: <20091209165646.41b9ce8a.sfr@canb.auug.org.au>
 <Pine.LNX.4.44L0.0912091026210.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0912091026210.4120-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 10:29:22AM -0500, Alan Stern wrote:
> On Wed, 9 Dec 2009, Stephen Rothwell wrote:
> 
> > Hi Greg,
> > 
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > drivers/net/usb/kaweth.c: In function 'kaweth_open':
> > drivers/net/usb/kaweth.c:719: error: implicit declaration of function 'usb_autopm_enable'
> > 
> > Caused by commit b3f937e6ddf3e60ed9b4c26349b7b171dffdd010 ("USB: prepare
> > for changover to Runtime PM framework").
> > 
> > I have reverted that commit for today.
> 
> This should have been okay because of Oliver's patch:
> 
> 	http://marc.info/?l=linux-netdev&m=125071045301270&w=2
> 
> which removed the offending reference.  Hasn't it been merged yet?  
> It was submitted back in August.

Hm, I thought I saw this in David's network tree in linux-next, but
perhaps that was the wifi and one other patch, I didn't look for the
kaweth patch.

David, any ideas if the patch above was just dropped for some reason.
If it was just overlooked, I can take it through my tree, as I depend on
it to not break the build.

thanks,

greg k-h
