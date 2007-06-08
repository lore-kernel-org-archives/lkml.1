Return-Path: <linux-kernel-owner+w=401wt.eu-S970630AbXFHQan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970630AbXFHQan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966259AbXFHQad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:30:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44280 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965973AbXFHQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:30:32 -0400
Subject: Re: [usb-storage] 2.6.22-rc4-mm2 - usb-storage
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0706081011250.3473-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0706081011250.3473-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 18:30:28 +0200
Message-Id: <1181320228.7348.290.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 10:16 -0400, Alan Stern wrote:
> [Trimmed the recipients list]
> 
> On Fri, 8 Jun 2007, Peter Zijlstra wrote:
> 
> > On Thu, 2007-06-07 at 18:20 -0400, Alan Stern wrote:
> > > On Thu, 7 Jun 2007, Peter Zijlstra wrote:
> > > 
> > > > My kernel went chatty when I tried to access my usb-stick; which it
> > > > didn't seem to find.
> ....
> > > This is false-alarm output from something intended to track down a 
> > > reported bug.  The patch responsible is this one: 
> > 
> > Right, well then I have another problem. Because it doesn't find my
> > usb-stick.
> > 
> > I noticed from D states (quite easy to reproduce, just modprobe
> > usb-storage):
> > 
> > scsi_eh_6     D ffff8100079ed640     0  3568      2 (L-TLB)
> >  ffff81000ac45e10 0000000000000046 0000000000000000 0000000180252936
> >  0000000000000002 0000000100000000 ffff81000ac42700 ffff8100043ca240
> >  ffff81000ac42978 ffffffff8024fc8d 00000000000000ff ffff81000ac42700
> > Call Trace:
> >  [<ffffffff804775a9>] wait_for_completion+0x82/0xc1
> >  [<ffffffff88201673>] :usb_storage:command_abort+0x7c/0x86
> >  [<ffffffff8805f54f>] :scsi_mod:scsi_error_handler+0x28e/0x4cc
> >  [<ffffffff8024a7ff>] kthread+0x47/0x74
> >  [<ffffffff8020cc28>] child_rip+0xa/0x12
> 
> Okay, this is a separate problem.  To help diagnose it, please turn on 
> CONFIG_USB_DEBUG and CONFIG_USB_STORAGE_DEBUG and then post the 
> resulting dmesg log.

Here goes:

 http://programming.kicks-ass.net/misc/dmesg


