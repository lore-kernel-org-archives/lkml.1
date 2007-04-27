Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXD0TCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXD0TCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbXD0S70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:59:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48447 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbXD0S7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:59:06 -0400
Date: Fri, 27 Apr 2007 11:56:46 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] USB patches for 2.6.21
Message-ID: <20070427185646.GA17578@kroah.com>
References: <20070427185422.GA17509@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427185422.GA17509@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 11:54:22AM -0700, Greg KH wrote:
> Here are some USB patches against your 2.6.21 tree.
> 
> They do the following:
>   - new gadget driver
>   - loads of race fixes from Oliver
>   - USB autosuspend reworks and fixes from Alan
>   - lots of new device ids and other minor fixes
> 
> Almost all of these have been in the -mm releases for a while, with the
> exception of a few minor device id additions, and one new gadget driver.
> 
> Note, there is one build dependancy on the driver core patches that I
> sent you already.

Ugh, I just realized that this mite break people using 'git bisect' and
diving down into this usb branch.  If you want, I can just redo this
whole tree after you pull the driver patches so this doesn't happen.

Sorry about that.

greg k-h
