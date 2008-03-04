Return-Path: <linux-kernel-owner+w=401wt.eu-S934995AbYCDX5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934995AbYCDX5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934992AbYCDX4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:56:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37282 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934698AbYCDX4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:56:00 -0500
Date: Tue, 4 Mar 2008 15:55:47 -0800
From: Greg KH <greg@kroah.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 possible regression usbfs options ignored?
Message-ID: <20080304235547.GD3773@kroah.com>
References: <20080303215456.GA7747@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303215456.GA7747@ics.muni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:54:56PM +0100, Lukas Hejtmanek wrote:
> Hello,
> 
> I'm using 2.6.25-rc3. It seems that options for usbfs (devgid and devmode) are
> ignored.
> 
> # mount | grep usbfs
> none on /proc/bus/usb type usbfs (rw,devgid=46,devmode=0664)
> 
> /proc/bus/usb# ls -l
> total 0
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 001
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 002
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 003
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 004
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 005
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 006
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 007
> -r--r--r-- 1 root root 0 2008-03-03 22:30 devices
> 
> or am I just someting missing?

 CC:ing the linux-usb mailing list might help out more :)

parsing the options did change a bit in 2.6.25-rc, but I don't think it
would have changed this.  Can you revert the patch at git id
2e4f3c02239d4c7c454604715db619bc971b15eb and see if it fixes the problem
for you or not?

Hm, I see this here as well, not good...

thanks,

greg k-h
