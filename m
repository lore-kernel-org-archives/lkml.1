Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbZCSELc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbZCSELc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 00:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZCSELZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 00:11:25 -0400
Received: from kroah.org ([198.145.64.141]:34726 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751261AbZCSELY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 00:11:24 -0400
Date: Wed, 18 Mar 2009 21:08:09 -0700
From: Greg KH <greg@kroah.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090319040809.GA29249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's 5 patches that add the Intel Poulsbo/Morrestown DRM driver to the
kernel tree.

There are 4 patches that make changes to the DRM core, and one patch
that adds the DRM driver itself.  The driver is added to the
drivers/staging/ directory because it is not the "final" driver that
Intel wishes to support over time.  The userspace api is going to
change, and work is currently underway to hook up properly with the
memory management system.

However this work is going to take a while, and in the meantime, users
want to run Linux on this kind of hardware.  I'd really like to add the
driver to the staging tree, but it needs these core DRM changes in order
to get it to work properly.

Originally I had a patch that basically duplicated the existing DRM
core, and embedded it with these changes and the PSB driver together
into one big mess of a kernel module.  But Richard convinced me that
this wasn't the "nicest" thing to do, and he did work on the PSB code
and dug out these older DRM patches.

The only thing that looks a bit "odd" to me is the unlocked ioctl patch,
Thomas, is that thing really correct?

David, I'd be glad to take the DRM changes through the staging tree, but
only if you ack them.

thanks,

greg k-h
