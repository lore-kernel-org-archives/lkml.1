Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbXDLU0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbXDLU0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXDLU0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:26:10 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55218 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751738AbXDLU0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:26:08 -0400
Date: Thu, 12 Apr 2007 22:19:13 +0200
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Corey Minyard <minyard@acm.org>
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070412201913.GA14705@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 05:31:52PM +0200, Jiri Kosina wrote:
> On Thu, 12 Apr 2007, Jiri Kosina wrote:
> 
> > > - try booting without any HID devices plugged in (i.e. usb mice, usb 
> > >   keyboards) if the problem persists?
> > > - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?
> > Do you compile with CONFIG_HIDRAW?
> 
> Helge,
> 
> with your .config, my machine hangs upon IPMI initialization, the last 
> thing I see before total freeze is 
> 
> ipmi_si: Trying PCI-specified kcs state machine at mem address 0xd0121000, slave address 0x0, irq 5
> 
> (this was run on 32bit machine)
> 
> When I turn IPMI off, I can't reproduce your hang, evetything runs 
> smoothly. Could you please try recompiling the kernel with IPMI disabled, 
> if it could be related?
> 
Removed IPMI, recompiled, rebooted, crashed the same way.

Helge Hafting
