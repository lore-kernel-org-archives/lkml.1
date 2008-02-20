Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYBTGdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYBTGdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYBTGdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:33:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37983 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYBTGdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:33:24 -0500
Date: Tue, 19 Feb 2008 22:20:43 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: Status of storage autosuspend
Message-ID: <20080220062043.GA22308@kroah.com>
References: <20080218222014.GB31201@elf.ucw.cz> <Pine.LNX.4.44L0.0802182214060.18685-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802182214060.18685-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 10:19:11PM -0500, Alan Stern wrote:
> On Mon, 18 Feb 2008, Pavel Machek wrote:
> 
> > > Should we ignore this issue and submit the patches anyway?
> > 
> > I think you should. "Easy" (and clean) solution to that issue is to
> > just return -EPERM from SG_IOCTL if autosuspend is configured in ;-).
> 
> :-)
> 
> Okay, I'll update the patches to 2.6.25-rc2 and submit them in a few
> days.  (Actually the SCSI patch has to go in first and the usb-storage
> patch afterward, which will probably cause it to be delayed one kernel
> version.  I don't know any good way to handle these cross-subsystem
> updates...)

Push the usb-storage one through the scsi tree as well.  The subsystem
maintainers handle this kind of thing all the time (for example, a sysfs
feature is about to go in through the ocfs tree for this very reason.)

thanks,

greg k-h
