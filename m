Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYAXUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYAXUou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbYAXUh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:37:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbYAXUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:37:26 -0500
Date: Thu, 24 Jan 2008 12:28:33 -0800
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Wilco Beekhuizen <wilcobeekhuizen@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Message-ID: <20080124202833.GA3216@kroah.com>
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <84144f020801240942y1c75c82geddc250b7e7814ac@mail.gmail.com> <20080124180313.GA16006@kroah.com> <200801242100.22090.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801242100.22090.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 09:00:21PM +0100, Oliver Neukum wrote:
> Am Donnerstag, 24. Januar 2008 19:03:13 schrieb Greg KH:
> > And the unplug issue at a filesystem level should be pretty trivial to
> > handle, we do it all the time in /proc and /sys and other virtual
> > filesystems (usbfs) with no problems.
> 
> A discussion about lifetime rules for objects in sysfs anyone? ;->

The objects (kobjects) are now separate from the sysfs core internals,
so this should all be fixed up now :)

Anyway, sysfs is (hopefully) different from this filesystem, it should
be able to be done using all of the ramfs code, and no "special" backing
logic would be needed.  Like usbfs...

And if you see problems in the usbfs implementation with regards to
lifetime rules (becides the devices file), please let me know.

thanks,

greg k-h
