Return-Path: <linux-kernel-owner+w=401wt.eu-S1764508AbYBBTKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764508AbYBBTKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYBBTKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:10:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYBBTK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:10:29 -0500
Date: Sat, 2 Feb 2008 10:55:07 -0800
From: Greg KH <greg@kroah.com>
To: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-hotplug@vger.kernel.org
Subject: Re: udevd induced deadlock in loading kernel modules?
Message-ID: <20080202185507.GC13005@kroah.com>
References: <47A4522C.8090403@vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A4522C.8090403@vc.cvut.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 03:21:16AM -0800, Petr Vandrovec wrote:
> Mailer on sf.net says that email address in udev's README is obsolete. 
> Oops...
> 						Petr
>
> -------- Original Message --------
> Subject: udevd induced deadlock in loading kernel modules?
> Date: Sat, 2 Feb 2008 12:07:19 +0100
> From: Petr Vandrovec <petr@vandrovec.name>
> To: linux-kernel@vger.kernel.org
> CC: linux-hotplug-devel@lists.sourceforge.net
>
> Hello,
>   today my system hung during boot, while loading ftdi_sio & loop - I have 
> two ftdi serial ports,
> and apparently this tricked udevd to start two concurrent modprobes for 
> them - so I ended up with
> strance "ftdi_sio: gave up waiting for init of module usbserial." for each 
> symbol it tried to
> import, until I kill-9 process 3137 (see below).  After that loop got 
> loaded, and second ftdi's
> load finished as well.
>
> Unfortunately I do not have stacktraces of hung modprobe processes. Maybe 
> next time, but it
> does not look very reproducible.
>
> Kernel is current git (2.6.24, ed50d6cbc394cd0966469d3e249353c9dd1d38b9), 
> udev is Debian's 0.114-2,
> and module-init-tools are Debian's 3.3-pre11-4.  Kernel is 64bit amd64 with 
> almost all debugging
> enabled, userspace is 32bit.

This sounds like a Debian bug in the init process logic.  Care to file a
bug in their system for it?

thanks,

greg k-h
