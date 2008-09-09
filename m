Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYIIHf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYIIHf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYIIHfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:35:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:40805 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYIIHfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:35:11 -0400
Date: Tue, 9 Sep 2008 00:33:56 -0700
From: Greg KH <greg@kroah.com>
To: Steve Calfee <stevecalfee@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net,
       Kernel development list <linux-kernel@vger.kernel.org>,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080909073356.GA12284@kroah.com>
References: <20080904214802.GO2772@parisc-linux.org> <Pine.LNX.4.44L0.0809051017280.2493-100000@iolanthe.rowland.org> <20080909005353.GR2772@parisc-linux.org> <4a5ff6bc0809090012j7121108cpc4cf108a4c323c52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a5ff6bc0809090012j7121108cpc4cf108a4c323c52@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 12:12:37AM -0700, Steve Calfee wrote:
> 
> My problem is I am using the latest Suse enterprise linux which uses
> kernel 2.6.18

Actually it's 2.6.16 "based" with over 2000 patches added to it :)

> ..... In that kernel the probes are done by the device
> system and if a modprobe definition says the module is for this device
> it gets loaded (by udev I think) and probed. fine. If the module is
> already loaded the kernel probes the modules in the order they were
> insmoded (if they say they want the particular VID/PID/CLASS/wildcard
> etc.)
> 
> The problem is the probing is done by the kernel driver stuff and the
> insmoding and user space intelligence is done by udev. Once a kernel
> module is installed it must take all devices that match it's device ID
> table.  Remember USBIP matches everything! That is because (at least
> in the 2.6.18 kernel) the kernel driver stuff stops probing after a
> probe fails.

No it doesn't, it continues on.  Or it should.  Perhaps it's been fixed
since then, I would rely on that kernel to be looking like anything
"real" these days, it is very old and only supported by Novell, and not
the target audience for this patch at all.

thanks,

greg k-h
