Return-Path: <linux-kernel-owner+w=401wt.eu-S1030970AbXFHSHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030970AbXFHSHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761979AbXFHSHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:07:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33260 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760027AbXFHSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:07:04 -0400
Date: Fri, 8 Jun 2007 11:07:03 -0700
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: blank filenames in /sys/modules, kernel 2.6.21
Message-ID: <20070608180703.GB11870@kroah.com>
References: <46699945.6020106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46699945.6020106@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 02:00:37PM -0400, Chuck Ebbert wrote:
> We just found a file with this name in 2.6.21:
> 
> Directory name: /sys/module/nousb/parameters
> File name:      ""

Hm, something went wrong there, 'nousb' should not be a module.

Do you have the usbcore built into the kernel, or as a module?

> IOW the file has an empty name. Is this intentional?
> It sure confuses updatedb...
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242715

I don't see the empty directory here:
/sys/module/nousb/parameters $ ls -la
total 0
drwxr-xr-x 2 root root    0 Jun  8 11:04 .
drwxr-xr-x 3 root root    0 Jun  4 16:59 ..
-r--r--r-- 1 root root 4096 Jun  8 11:04 usbcore.autosuspend

Care to send me a .config?

thanks,

greg k-h
