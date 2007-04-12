Return-Path: <linux-kernel-owner+w=401wt.eu-S2992579AbXDLPcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992579AbXDLPcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992567AbXDLPcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:32:48 -0400
Received: from twin.jikos.cz ([213.151.79.26]:57268 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992578AbXDLPcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:32:47 -0400
Date: Thu, 12 Apr 2007 17:31:52 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Helge Hafting <helgehaf@aitel.hist.no>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Corey Minyard <minyard@acm.org>
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
In-Reply-To: <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org>
 <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz>
 <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, Jiri Kosina wrote:

> > - try booting without any HID devices plugged in (i.e. usb mice, usb 
> >   keyboards) if the problem persists?
> > - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?
> Do you compile with CONFIG_HIDRAW?

Helge,

with your .config, my machine hangs upon IPMI initialization, the last 
thing I see before total freeze is 

ipmi_si: Trying PCI-specified kcs state machine at mem address 0xd0121000, slave address 0x0, irq 5

(this was run on 32bit machine)

When I turn IPMI off, I can't reproduce your hang, evetything runs 
smoothly. Could you please try recompiling the kernel with IPMI disabled, 
if it could be related?

Corey added to CC.

Thanks,

-- 
Jiri Kosina
