Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYH1XEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYH1XEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbYH1XEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:04:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43866 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYH1XEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:04:40 -0400
Date: Thu, 28 Aug 2008 16:00:16 -0700
From: greg@kroah.com
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Brian Merrell <bgmerrell@novell.com>,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>, gregkh@suse.de
Subject: [patch 00/03] USB-IP patches
Message-ID: <20080828230016.GA15014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's 3 patches that adds USB-IP functionality code to the kernel tree.

It is against 2.6.27-rc4, and has been added to the -staging tree.  If
there are no major objections, I'll also queue it up in the usb tree for
submission into 2.6.28.

The code is based on Takahiro's great work that has been sitting outside
of the kernel for many many years now.  Brian Merrell took the most
recent version of the code, cleaned it up and sent it to me.  I did more
cleanup and split the patch into 3 pieces, making it a bit easier to
work with.

There are still a number of checkpatch.pl warnings/errors emitted, and
Brian said he would work on them in the upcoming weeks, but they don't
distract from the basic functionality and a good review would be nice to
have.

We do need some more documentation for how to use this code (you need
the tools at usbip.sf.net), and how the sysfs files are exporting data
to userspace.  Brian, can you write up the sysfs interface in the format
that Documentation/ABI/ details and also provide some kind of basic
HOWTO to include in the kernel source tree?

thanks,

greg k-h
