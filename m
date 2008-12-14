Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbYLNTJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbYLNTJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 14:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYLNTJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 14:09:42 -0500
Received: from kroah.org ([198.145.64.141]:47041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750910AbYLNTJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 14:09:42 -0500
Date: Sun, 14 Dec 2008 11:08:29 -0800
From: Greg KH <greg@kroah.com>
To: Holger Hoffstaette <holger@wizards.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27.9
Message-ID: <20081214190829.GA31396@kroah.com>
References: <20081214001029.GA915@kroah.com> <pan.2008.12.14.08.06.53.334750@wizards.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2008.12.14.08.06.53.334750@wizards.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 09:06:53AM +0100, Holger Hoffstaette wrote:
> On Sat, 13 Dec 2008 16:10:29 -0800, Greg KH wrote:
> 
> > We (the -stable team) are announcing the release of the 2.6.27.9 kernel.
> 
> This is still missing the fix for the regression from .7 to .8 that I
> reported here:
> http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/00006.html
> 
> The fix is here:
> http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/00998.html
> 
> Been running that on top of -stable and it does fix the problem. It also
> seems to work for other people. Is there some particular reason why this
> was not included? I tested and cc'ed stable@ for a reason. :(

The patch is not in Linus's tree yet, right?  That is a requirement to
go into the -stable releases.

Also, it is not exactly obvious why a change for idr is needed.  The
"new" drm code in Fedora releases is understandable, but that is not
code that is in the main 2.6.27-stable tree, right?

Also, please cc: the stable developers if you want them to pay attention
to messages like this.

thanks,

greg k-h
