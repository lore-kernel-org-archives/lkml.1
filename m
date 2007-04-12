Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXDLQ7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXDLQ7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030405AbXDLQ7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:59:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49620 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbXDLQ7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:59:17 -0400
Date: Thu, 12 Apr 2007 09:55:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Corey Minyard <minyard@acm.org>,
       Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-Id: <20070412095531.d792f671.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	<20070411194227.GA31286@aitel.hist.no>
	<20070411134346.d10765da.akpm@linux-foundation.org>
	<20070411230700.GA4023@aitel.hist.no>
	<Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz>
	<Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz>
	<Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 17:31:52 +0200 (CEST) Jiri Kosina <jikos@jikos.cz> wrote:

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

Was that with ipmi linked into vmlinux?  (Please send the output of grep
IPMI .config)

I thought we fixed that.

