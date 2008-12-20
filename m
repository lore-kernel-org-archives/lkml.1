Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYLTBAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYLTBAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYLTBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:00:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:40328 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbYLTBAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:00:21 -0500
Date: Fri, 19 Dec 2008 16:46:06 -0800
From: Greg KH <gregkh@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.28-rc7: error in panic code? (NULL pointer dereference at
	0000004c)
Message-ID: <20081220004606.GA608@suse.de>
References: <19f34abd0812181406n48712c81j41a560aaf6ba6cd8@mail.gmail.com> <19f34abd0812190919g348b581ex9ebb2e83701899c7@mail.gmail.com> <20081219173946.GA18240@suse.de> <84144f020812191235u4106766bhee28134632c302e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020812191235u4106766bhee28134632c302e2@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 10:35:57PM +0200, Pekka Enberg wrote:
> Hi Greg,
> 
> On Fri, Dec 19, 2008 at 06:19:43PM +0100, Vegard Nossum wrote:
> > Fixes what?  It might be quite difficult to revert that patch now, as
> > the infrastructure is no longer in place to use a private pci device
> > list, that code is long gone.
> 
> Vegard forced one oops but got two! The first one is expected and but
> the second one shouldn't probably be there:

"Second" oopses are known to not be reliable, I wouldn't count it as a
real problem unless it happens on its own.

> >> > [    0.040993] EIP: [<c13b41dc>] klist_next+0x10/0x8d SS:ESP 0068:c165dd48
> 
> Looks like the patch Vegard identified breaks something in the oops path?

Very wierd, I also don't understand how reverting the specific patch
would even make a buildable system.

thanks,

greg k-h
