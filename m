Return-Path: <linux-kernel-owner+w=401wt.eu-S1763627AbZEAXDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763627AbZEAXDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZEAXDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:03:32 -0400
Received: from kroah.org ([198.145.64.141]:59271 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbZEAXDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:03:31 -0400
Date: Fri, 1 May 2009 15:56:16 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wedgwood <cw@f00f.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: Tree for May 1 (devtmpfs)
Message-ID: <20090501225616.GA18064@kroah.com>
References: <20090501163405.973f9088.sfr@canb.auug.org.au> <49FB1521.5050500@oracle.com> <20090501165551.GA1889@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501165551.GA1889@puku.stupidest.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 09:55:52AM -0700, Chris Wedgwood wrote:
> On Fri, May 01, 2009 at 08:28:33AM -0700, Randy Dunlap wrote:
> 
> > drivers/base/devtmpfs.c:41: error: implicit declaration of function 'vfs_mkdir'
> > drivers/base/devtmpfs.c:46: error: dereferencing pointer to incomplete type
> 
> [...]
> 
> Why is devtmpfs in linux-next?  My read of the thread so far seems to
> indicate there is considerable uncertainty that this is necessary or
> desirable.

As we discussed on irc, I think you no longer object to this, and see
how it solves a real problem, and can probably help out your initramfs
tools.

So it should stay in -next for now, and see if any build/use problems
happen with it.  I've been running it all this week on my machines just
fine.

thanks,

greg k-h
